//
//  SunViewController.swift
//  SunsetApp
//
//  Created by Angelique Babin on 24/09/2020.
//

import UIKit
import RealmSwift

final class SunViewController: UIViewController {
    
    // MARK: - Outlets

    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var dayLengthLabel: UILabel!
    @IBOutlet weak var activeButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var alarmView: UIView!
    @IBOutlet weak var choiceHourSegmentedControl: UISegmentedControl!
    @IBOutlet weak var choiceDaySegmentedControl: UISegmentedControl!
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet var baseView: UIView!
    @IBOutlet var remindersButtons: [UIButton]!
    @IBOutlet weak var reminderImageView: UIImageView!
    
    // MARK: - Properties
    
    private let sunService = SunService()
    private var sunApiResults: ResultsApi?
    private var sunNoFormattedApiResults: ResultsNoFormattedApi?
    private var currentDate = String()
    private var tomorrowDate = String()
    private var oldDate = String()
    private var sunList: Results<Sun>!
    private var sunNoFormattedList: Results<Sun>!
    private var currentDateNoFormatted = String()
    private var tomorrowDateNoFormatted = String()
    private var oldDateNoFormatted = String()
    private let dataManager = DataManager()
    private let realm = try? Realm()
    private var typeHour: Double = 1.0
    private var tomorrowInDate = Date()
    private var tomorrowNoFormattedInDate = Date()
    private let defaults = UserDefaults.standard
    private var notificationActive: Bool?
    
    public var completion: ((String, String, Date) -> Void)?
    private var reminds: [NotificationModel] = [NotificationModel]()

    // MARK: - Actions
    
    @IBAction func refreshBarButtonItemTapped(_ sender: UIBarButtonItem) {
        setData()
        getDateNoFormatted()
        loadUserDefaults()
        if reminds.isEmpty {
            reminderImageView.image = #imageLiteral(resourceName: "cancel")
        } else {
            reminderImageView.image = #imageLiteral(resourceName: "active")
        }
    }
    
    @IBAction func activeRemindButtonTapped(_ sender: UIButton) {
        setAlarm()
    }
    
    @IBAction func cancelRemindButtonTapped(_ sender: UIButton) {
        deleteReminder()
    }
    
    @IBAction func typeHourSelected(_ sender: UISegmentedControl) {
        UserSettings.segmentedTypeHour = choiceHourSegmentedControl.selectedSegmentIndex
        switch sender.selectedSegmentIndex {
        case 0:
            typeHour = 1
            getSunsetWithChoiceDay(sender: choiceDaySegmentedControl)
        default:
            typeHour = 2
            getSunsetWithChoiceDay(sender: choiceDaySegmentedControl)
        }
    }
    
    @IBAction func typeDaySelected(_ sender: UISegmentedControl) {
    UserSettings.segmentedTypeDay = choiceDaySegmentedControl.selectedSegmentIndex
    getSunsetWithChoiceDay(sender: sender)
}
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customUI()
        loadUserDefaults()
        getDates()
        setData()
        getDateNoFormatted()
        
        print("REALM : \(Realm.Configuration.defaultConfiguration.fileURL!)") // for db Realm Studio
        debug()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUserDefaults()
    }
    
    // MARK: - Methods
    
    private func customUI() {
        customButtons(buttons: remindersButtons, radius: 20, width: 0.8, colorBackground: .systemGroupedBackground, colorBorder: .systemIndigo)
        customView(view: alarmView, radius: 15, width: 2.0, colorBorder: .systemGray4)
        customShadowView(view: alarmView)
        customShadowButtons(buttons: remindersButtons)
        customImageView(imageView: reminderImageView, radius: 22, width: 0.8, colorBorder: .systemIndigo)
        customShadowImageView(imageView: reminderImageView)

    }

    private func loadUserDefaults() {
        let myTypeHour = UserSettings.segmentedTypeHour
        choiceHourSegmentedControl.selectedSegmentIndex = myTypeHour
        let myTypeDay = UserSettings.segmentedTypeDay
        choiceDaySegmentedControl.selectedSegmentIndex = myTypeDay
        
        let myNotification = UserSettings.notificationActive
        notificationActive = myNotification
        
        if reminds.isEmpty {
            reminderImageView.image = #imageLiteral(resourceName: "cancel")
        } else {
            reminderImageView.image = #imageLiteral(resourceName: "active")
        }
        
        guard let sunList = realm?.objects(Sun.self) else { return }
        for sun in sunList {
            typeHour = sun.typeHour
        }
    }
    
    fileprivate func getSunsetWithChoiceDay(sender: UISegmentedControl) { // choiceDaySegmentedControl
        let choiceDay = sender.selectedSegmentIndex
        switch choiceDay {
        case 0:
            getSunsetSunrise(date: currentDate)
            getSunsetSunriseNoFormatted(date: currentDate)

        default:
            getSunsetSunrise(date: tomorrowDate)
            getSunsetSunriseNoFormatted(date: tomorrowDate)

        }
    }
    
    private func getDates() {
        getDatesFormatted()
        getDatesNoFormatted()
        setTomorrowDates()
    }
    
    private func getDatesFormatted() {
//        currentDate = "2020-10-01"
        currentDate = currentDate.getCurrentDate(dateFormat: FormatDate.formatted.rawValue)
        guard let sunList = realm?.objects(Sun.self) else { return }
        oldDate = oldDate.getOldDate(sunList: sunList)
    }
    
    private func getDatesNoFormatted() {
//        currentDateNoFormatted = "2020-10-01T05:44:57+00:00"
        currentDateNoFormatted = currentDateNoFormatted.getCurrentDate(dateFormat: FormatDate.noFormatted.rawValue)
        guard let sunNoFormattedList = realm?.objects(SunNoFormatted.self) else { return }
        oldDateNoFormatted = oldDateNoFormatted.getOldDateNoFormatted(sunNoFormattedList: sunNoFormattedList)
    }
    
    private func setTomorrowDates() {
        tomorrowInDate = currentDate.toDate().addingTimeInterval(24 * 60 * 60)
        tomorrowDate = tomorrowInDate.toString(format: FormatDate.formatted.rawValue)
        tomorrowNoFormattedInDate = currentDateNoFormatted.toDate().addingTimeInterval(24 * 60 * 60)
        tomorrowDateNoFormatted = tomorrowNoFormattedInDate.toString(format: FormatDate.noFormatted.rawValue)
    }
    
    private func setData() {
        if oldDate == currentDate {
            setDataLabels()
            toggleActivityIndicator(shown: false,
                                    activityIndicator: self.activityIndicator,
                                    view: self.baseView)
        } else {
            getSunsetSunrise(date: currentDate)
            getSunsetSunriseNoFormatted(date: currentDate)
        }
    }
    
    private func getDateNoFormatted() {
        if oldDate == currentDate {
            setDataLabels()
            toggleActivityIndicator(shown: false,
                                    activityIndicator: self.activityIndicator,
                                    view: self.baseView)
        } else {
            getSunsetSunriseNoFormatted(date: currentDate)
        }
        debugGetDateNoFormatted()
    }
    
    private func getSunsetSunrise(date: String) {
        dataManager.deleteAllDataSun(realm: realm)
        sunService.getSunsetSunrise(date: date) { (success, sunApi) in // currentDate
            self.toggleActivityIndicator(shown: false,
                                         activityIndicator: self.activityIndicator,
                                         view: self.baseView)
            if success {
                guard let sunApi = sunApi else { return }
                if sunApi.status == "OK" {
                    self.sunApiResults = sunApi.results
                    self.setLabels(typeHour: self.typeHour)
                    let data = StructDataManager(sunApiResults: self.sunApiResults,
                                                 currentDate: self.currentDate,
                                                 tomorrowDate: self.tomorrowDate,
                                                 realm: self.realm)
                    self.dataManager.saveDataSun(data: data, oldDate: &self.oldDate, typeHour: self.typeHour)
                    self.dataManager.displaySunCount(realm: self.realm)
                    print("typeHour in getSunsetSunrise : \(self.typeHour)")
                    print("tomorrowDate in getSunsetSunrise : \(self.tomorrowDate)")
                } else {
                    self.presentAlert(typeError: .error)
                    self.toggleActivityIndicator(shown: false,
                                                 activityIndicator: self.activityIndicator,
                                                 view: self.baseView)
                }
            } else {
                self.presentAlert(typeError: .error)
                self.toggleActivityIndicator(shown: false,
                                             activityIndicator: self.activityIndicator,
                                             view: self.baseView)
            }
        }
    }
    
    private func getSunsetSunriseNoFormatted(date: String) {
        dataManager.deleteAllDataSunNoFormatted(realm: realm)
        sunService.getSunsetSunriseNoFormatted(date: date) { (success, sunApi) in // currentDate: currentDate
            self.toggleActivityIndicator(shown: false,
                                         activityIndicator: self.activityIndicator,
                                         view: self.baseView)
            if success {
                guard let sunApi = sunApi else { return }
                if sunApi.status == "OK" {
                    self.sunNoFormattedApiResults = sunApi.results
                    let data = StructDataManagerNoFormatted(sunApiResultsNoFormatted: self.sunNoFormattedApiResults,
                                                            currentDate: self.currentDateNoFormatted,
                                                            tomorrowDate: self.tomorrowDateNoFormatted,
                                                            realm: self.realm)
                    self.dataManager.saveDataSunNoFormatted(data: data, oldDateNoFormatted: &self.oldDateNoFormatted)
                    self.dataManager.displaySunCount(realm: self.realm)
                } else {
                    self.presentAlert(typeError: .error)
                    self.toggleActivityIndicator(shown: false,
                                                 activityIndicator: self.activityIndicator,
                                                 view: self.baseView)
                }
            } else {
                self.presentAlert(typeError: .error)
                self.toggleActivityIndicator(shown: false,
                                             activityIndicator: self.activityIndicator,
                                             view: self.baseView)
            }
        }
    }
    
    private func setDayLabel() {
        if choiceDaySegmentedControl.selectedSegmentIndex == 0 {
            dayLabel.text = FormatDate.today.rawValue // "Today"
            currentDateLabel.text = currentDate.getCurrentDate(dateFormat: FormatDate.toDisplay.rawValue)
        } else {
            dayLabel.text = FormatDate.tomorrow.rawValue // "Tomorrow"
            currentDateLabel.text = tomorrowInDate.toString(format: FormatDate.toDisplay.rawValue)
        }
    }
    
    private func setLabels(typeHour: Double) {
        sunsetLabel.text = sunApiResults?.sunset.date24(typeHour: typeHour)
        sunriseLabel.text = sunApiResults?.sunrise.date24(typeHour: typeHour)
        dayLengthLabel.text = sunApiResults?.dayLength
        setDayLabel()
    }
    
    private func setDataLabels() {
        guard let sunList = realm?.objects(Sun.self) else { return }
        for sun in sunList {
            let sunset = sun.sunset
            let sunrise = sun.sunrise
            let dayLength = sun.dayLength
            sunsetLabel.text = sunset
            sunriseLabel.text = sunrise
            dayLengthLabel.text = dayLength
            setDayLabel()
            
            debugSetDataLabels(sunset, sunrise, dayLength, sun)
        }
    }

    private func setAlarm() { // day: String
        var targetDateToday = Date().addingTimeInterval(10)
        var targetDateTomorrow = Date().addingTimeInterval(15)
        
//        guard let sunNoFormattedList = realm?.objects(SunNoFormatted.self) else { return }
//        for sun in sunNoFormattedList {
//            targetDateToday = sun.sunset.toDate().addingTimeInterval(1.5 * 60 * 60)
//            targetDateTomorrow = sun.sunset.toDate().addingTimeInterval(25.5 * 60 * 60)
//        }

        let choiceDay = choiceDaySegmentedControl.selectedSegmentIndex
        let title = "Bye Bye Sun !"
        let body = "- The sun has set. The shutters must be closed !!!"
//        print("targetDateToday in SetAlarm : \(targetDateToday)")
//        print("targetDateTomorrow in SetAlarm : \(targetDateTomorrow)")
        switch choiceDay {
        case 0:
            guard let sunNoFormattedList = realm?.objects(SunNoFormatted.self) else { return }
//            for sun in sunNoFormattedList {
//                targetDateToday = sun.sunset.toDate().addingTimeInterval(1.5 * 60 * 60)
//            }
            let title = title
            let body = "\(targetDateToday)" + body
            print("targetDateToday in SetAlarm : \(targetDateToday)")
            completion?(title, body, targetDateToday)
        default:
            guard let sunNoFormattedList = realm?.objects(SunNoFormatted.self) else { return }
//            for sun in sunNoFormattedList {
//                targetDateTomorrow = sun.sunset.toDate().addingTimeInterval(1.5 * 60 * 60)
//            }
            let title = title
            let body = "\(targetDateTomorrow)" + body
            print("targetDateTomorrow in SetAlarm : \(targetDateTomorrow)")
            completion?(title, body, targetDateTomorrow)
        }
        
        activationAlarm()
    }
    
    private func activationAlarm() {
        deleteReminder()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { success, error in
            if success {
                self.createReminder()
            } else if error != nil {
                print("error occurred")
            }
        })
    }
    
    private func createReminder() {
        completion = { title, body, date in
            DispatchQueue.main.async {
                let notificationModel = NotificationModel(title: title, message: body, plannedFor: date)
                self.reminds.append(notificationModel)
                NotificationHelper.addLocalNotification(notificationModel)
                self.reminderImageView.image = #imageLiteral(resourceName: "active")
                self.notificationActive = true
                UserSettings.notificationActive = self.notificationActive ?? true
            }
        }
    }
    
    private func deleteReminder() {
        if reminds.isEmpty {
            print("no scheduled reminder")
        } else {
            reminds.removeAll()
            self.reminderImageView.image = #imageLiteral(resourceName: "cancel")
            self.notificationActive = false
            UserSettings.notificationActive = self.notificationActive ?? false

//            reminds.forEach { remind in
//                reminds.removeAll { rem -> Bool in
//                    if remind.id == rem.id {
//                        NotificationHelper.removeLocalNotification(rem)
//                    }
//                    print("rem.id is deleted : \(rem.id)")
//                    print("remind.id is : \(remind.id)")
//                    print("")
//                    return remind.id == rem.id
//                }
//            }
        }
    }
}

// MARK: - Debug

extension SunViewController {
    
    fileprivate func debug() {
        debugViewDidLoad()
        debugRealmSun()
        debugRealmSunNoFormatted()
    }

    fileprivate func debugViewDidLoad() {
        print("oldDate in viewdidload : \(oldDate) - currentDate : \(currentDate)")
        print("oldDateNoFormatted in viewdidload : \(oldDateNoFormatted) - currentDateNoFormatted : \(currentDateNoFormatted)")
        print("tomorrowDate in viewdidload : \(tomorrowDate) - tomorrowDateNoFormatted : \(tomorrowDateNoFormatted)")
        print("")
    }

    fileprivate func debugSetDataLabels(_ sunset: String, _ sunrise: String, _ dayLength: String, _ sun: Sun) {
        print("In setDataLabels --- Sun => ")
        print("sunset : \(sunset)")
        print("sunrise : \(sunrise)")
        print("dayLength : \(dayLength)")
        print("currentDate : \(currentDate)")
        print("oldDate : \(oldDate)")
        print("tomorrowDate : \(tomorrowDate)")
        print("typeHour : \(typeHour)")
        print("sun.typeHour : \(sun.typeHour)")
        print("")
    }

    fileprivate func debugGetDateNoFormatted() {
        guard let sunNoFormattedList = realm?.objects(SunNoFormatted.self) else { return }
        for sun in sunNoFormattedList {
            let sunset = sun.sunset
            let sunrise = sun.sunrise
            let dayLength = sun.dayLength
            print("In getDateNoFormatted --- Sun with dates not formatted => ")
            print("sunset : \(sunset)")
            print("sunrise : \(sunrise)")
            print("dayLength : \(dayLength)")
            print("currentDate : \(currentDateNoFormatted)")
            print("oldDate : \(oldDateNoFormatted)")
            print("tomorrowDate : \(tomorrowDateNoFormatted)")
            print("typeHour : \(typeHour)")
            print("")
        }
    }

    fileprivate func debugRealmSun() {
        guard let sunList = realm?.objects(Sun.self) else { return }
        for sun in sunList {
            print("Sun => ")
            print("sunset - viewDidLoad: \(sun.sunset)")
            print("sunrise - viewDidLoad: \(sun.sunrise)")
            print("dayLength - viewDidLoad: \(sun.dayLength)")
            print("sun.oldDate - viewDidLoad: \(sun.oldDate)")
            print("sun.currentDate - viewDidLoad: \(sun.currentDate)")
            print("sun.tomorrowDate - viewDidLoad: \(sun.tomorrowDate)")
            print("sun.typeHour - viewDidLoad: \(sun.typeHour)")
            print("oldDate - viewDidLoad: \(oldDate)")
            print("currentDate - viewDidLoad: \(currentDate)")
            print("tomorrowDate - viewDidLoad: \(tomorrowDate)")
            print("typeHour - viewDidLoad: \(typeHour)")
            print("")
        }
    }

    fileprivate func debugRealmSunNoFormatted() {
        guard let sunNoFormattedList = realm?.objects(SunNoFormatted.self) else { return }
        for sun in sunNoFormattedList {
            print("Sun with dates not formatted => ")
            print("sunset - viewDidLoad: \(sun.sunset)")
            print("sunrise - viewDidLoad: \(sun.sunrise)")
            print("dayLength - viewDidLoad: \(sun.dayLength)")
            print("sun.oldDate - viewDidLoad: \(sun.oldDate)")
            print("sun.currentDate - viewDidLoad: \(sun.currentDate)")
            print("sun.tomorrowDate - viewDidLoad: \(sun.tomorrowDate)")
            print("oldDate - viewDidLoad: \(oldDate)")
            print("currentDate - viewDidLoad: \(currentDate)")
            print("tomorrowDate - viewDidLoad: \(tomorrowDate)")
            print("typeHour - viewDidLoad: \(typeHour)")
            print("")
        }
    }
}

// private func setAlarm(day: String) =>
// todo switch
//        if choiceDaySegmentedControl.selectedSegmentIndex == 0 {
//            let body = "The sun has set. The shutters must be closed !!!"
//            let title = "Bye Bye Sun !"
//            completion?(title, body, targetDateToday)
//        } else {
//            let body = "The sun has set. The shutters must be closed !!!"
//            let title = "Bye Bye Sun !"
//            completion?(title, body, targetDateTomorrow)
//        }
