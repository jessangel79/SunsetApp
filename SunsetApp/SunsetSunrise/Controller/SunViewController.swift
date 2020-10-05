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
//    private var typeDay = "Today"
    private var tomorrowInDate = Date()
    private var tomorrowNoFormattedInDate = Date()
    private let defaults = UserDefaults.standard
    
    public var completion: ((String, String, Date) -> Void)?
    private var reminds: [NotificationModel] = [NotificationModel]()

    // MARK: - Actions
    
    @IBAction func refreshBarButtonItemTapped(_ sender: UIBarButtonItem) {
        setData()
        getDateNoFormatted()
    }
    
    @IBAction func activeRemindButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func cancelRemindButtonTapped(_ sender: UIButton) {
    
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
//        checkSwitch(type: "Sunset", switchObject: alarmSunsetSwitch)
        
        // for Realm Studio
        print("REALM : \(Realm.Configuration.defaultConfiguration.fileURL!)")
        print("")

        // debug
        print("oldDate in viewdidload : \(oldDate) - currentDate : \(currentDate)")
        print("oldDateNoFormatted in viewdidload : \(oldDateNoFormatted) - currentDateNoFormatted : \(currentDateNoFormatted)")
        print("tomorrowDate in viewdidload : \(tomorrowDate) - tomorrowDateNoFormatted : \(tomorrowDateNoFormatted)")
        print("")

        debugRealmSun()
        debugRealmSunNoFormatted()
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
        default:
            getSunsetSunrise(date: tomorrowDate)
        }
    }
    
    private func getDates() {
//        currentDate = "2020-10-01"
        currentDate = currentDate.getCurrentDate(dateFormat: FormatDate.formatted.rawValue)
        guard let sunList = realm?.objects(Sun.self) else { return }
        oldDate = oldDate.getOldDate(sunList: sunList)
        
//        currentDateNoFormatted = "2020-10-01T05:44:57+00:00"
        currentDateNoFormatted = currentDateNoFormatted.getCurrentDate(dateFormat: FormatDate.noFormatted.rawValue)
        guard let sunNoFormattedList = realm?.objects(SunNoFormatted.self) else { return }
        oldDateNoFormatted = oldDateNoFormatted.getOldDateNoFormatted(sunNoFormattedList: sunNoFormattedList)
        
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
        }
    }
    
    private func getDateNoFormatted() {
        if oldDate == currentDate {
            setDataLabels()
            toggleActivityIndicator(shown: false,
                                    activityIndicator: self.activityIndicator,
                                    view: self.baseView)
        } else {
            getSunsetSunriseNoFormatted()
        }
        
        debugGetDateNoFormatted()
    }
    
    private func setAlarm(day: String) {
//        guard let sunNoFormattedList = realm?.objects(SunNoFormatted.self) else { return }
        var targetDateToday = Date().addingTimeInterval(15)
        var targetDateTomorrow = Date().addingTimeInterval(30)
//        for sun in sunNoFormattedList {
//            targetDateToday = sun.sunset.toDate()
//            targetDateTomorrow = sun.tomorrowDate.toDate()
//        }
        if choiceDaySegmentedControl.selectedSegmentIndex == 0 {
            let body = "The sun has set. The shutters must be closed !!!"
            let title = "Bye Bye Sun !"
            completion?(title, body, targetDateToday)
        } else {
            let body = "The sun has set. The shutters must be closed !!!"
            let title = "Bye Bye Sun !"
            completion?(title, body, targetDateTomorrow)
        }
        activationAlarm()
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
    
    private func getSunsetSunriseNoFormatted() {
        dataManager.deleteAllDataSunNoFormatted(realm: realm)
        sunService.getSunsetSunriseNoFormatted(currentDate: currentDate) { (success, sunApi) in
            self.toggleActivityIndicator(shown: false,
                                         activityIndicator: self.activityIndicator,
                                         view: self.baseView)
            if success {
                guard let sunApi = sunApi else { return }
                if sunApi.status == "OK" {
                    self.sunNoFormattedApiResults = sunApi.results
                    let data = StructDataManagerNoFormatted(sunApiResults: self.sunNoFormattedApiResults,
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
    
    private func checkSwitch(type: String, switchObject: UISwitch) {
        if switchObject.isOn == true {
            setAlarm(day: type)
        }
        print("checkSwitch : \(switchObject.isOn)")
    }

    private func createReminder() {
        completion = { title, body, date in
            DispatchQueue.main.async {
                let notificationModel = NotificationModel(title: title, message: body, plannedFor: date)
                self.reminds.append(notificationModel)
                NotificationHelper.addLocalNotification(notificationModel)
            }
        }
    }
    
    private func deleteReminder() {
        if reminds.isEmpty {
            print("no scheduled reminder")
        } else {
            reminds.forEach { remind in
                reminds.removeAll { rem -> Bool in
                    if remind.id == rem.id {
                        NotificationHelper.removeLocalNotification(rem)
                    }
                    print("rem.id is deleted : \(rem.id)")
                    print("remind.id is : \(remind.id)")
                    print("")
                    return remind.id == rem.id
                }
            }
        }
    }
    
    private func activationAlarm() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { success, error in
            if success {
                self.createReminder()
            } else if error != nil {
                print("error occurred")
            }
        })
    }
}

// MARK: - Debug

extension SunViewController {
    
    // debug
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

    // debug
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
    
    // debug
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
    
    // debug
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
