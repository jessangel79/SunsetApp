//
//  SunViewController.swift
//  SunsetApp
//
//  Created by Angelique Babin on 24/09/2020.
//

import UIKit
import RealmSwift
import UserNotifications

final class SunViewController: UIViewController {
    
    // MARK: - Outlets

    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var dayLengthLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var alarmView: UIView!
    @IBOutlet weak var sunsetSwitch: UISwitch!
    @IBOutlet weak var choiceHourSegmentedControl: UISegmentedControl!
    @IBOutlet weak var choiceDaySegmentedControl: UISegmentedControl!
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet var baseView: UIView!
    
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
    
    public var completion: ((String, String, Date) -> Void)?
    private var reminds: [NotificationModel] = [NotificationModel]()

    // MARK: - Actions
    
    @IBAction func refreshBarButtonItemTapped(_ sender: UIBarButtonItem) {
        refresh()
        print("My reminders in refreshBarButtonItemTapped :\(reminds)")
        print("sunsetSwitch.isOn in refreshBarButtonItemTapped :\(sunsetSwitch.isOn)")
    }
    
    @IBAction func sunsetButtonClicked(_ sender: UISwitch) {
        sender.isOn ? activateRemind() : cancelRemind()
        UserSettings.stateSunsetSwitch = sunsetSwitch.isOn
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
        NotificationHelper.removeAllLocalNotificationDelivered()
        reminds = [NotificationModel]()
        loadUserDefaults()
        checkIfRemindIsActive()
        setSunList()
        getDates()
        setData()
        setAlarm()
        print("REALM : \(Realm.Configuration.defaultConfiguration.fileURL!)") // for db Realm Studio
        debug()
    }
    
    // MARK: - Methods
    
    private func customUI() {
        customView(view: alarmView, radius: 15, width: 2.0, colorBorder: .systemGray4)
        customShadowView(view: alarmView)
    }

    private func loadUserDefaults() {
        let myTypeHour = UserSettings.segmentedTypeHour
        choiceHourSegmentedControl.selectedSegmentIndex = myTypeHour
        let myTypeDay = UserSettings.segmentedTypeDay
        choiceDaySegmentedControl.selectedSegmentIndex = myTypeDay
        let mySunsetSwitch = UserSettings.stateSunsetSwitch
        sunsetSwitch.isOn = mySunsetSwitch
    }
    
    private func refresh() {
        setData()
        getDates()
        loadUserDefaults()
        checkIfRemindIsActive()
        sunsetSwitch.isOn = false
        setSunList()
    }
 
    private func setSunList() {
        guard let sunList = realm?.objects(Sun.self) else { return }
        for sun in sunList {
            typeHour = sun.typeHour
        }
    }
    
    private func getSunsetWithChoiceDay(sender: UISegmentedControl) { // choiceDaySegmentedControl
        let choiceDay = sender.selectedSegmentIndex
        switch choiceDay {
        case 0:
            getSunsetSunrise(date: currentDate)
            getSunsetSunriseNoFormatted(date: currentDate)
        default:
            getSunsetSunrise(date: tomorrowDate)
            getSunsetSunriseNoFormatted(date: tomorrowDate)
        }
        refresh()
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
}

// MARK: - Reminder

extension SunViewController {
    
    private func checkIfRemindIsActive() {
        if sunsetSwitch.isOn {
            createReminderWithAlert()
        } else {
            reminds.removeAll()
            NotificationHelper.removeAllLocalNotification()
        }
        print("My reminders in check if :\(reminds)")
    }
    
    private func setAlarm() {
        var targetDateToday = Date().addingTimeInterval(15)
        var targetDateTomorrow = Date().addingTimeInterval(20)

        let choiceDay = choiceDaySegmentedControl.selectedSegmentIndex
        let title = "Bye Bye Sun !"
        let body = "The sun has set. The shutters must be closed !!!"
        
        switch choiceDay {
        case 0:
            guard let sunNoFormattedList = realm?.objects(SunNoFormatted.self) else { return }
            for sun in sunNoFormattedList {
                targetDateToday = sun.sunset.toDate().advanced(by: 0.5 * 60 * 60) // .addingTimeInterval(1.5 * 60 * 60)
            }
            print("targetDateToday in SetAlarm : \(targetDateToday)")
            completion?(title, body, targetDateToday)
        default:
            guard let sunNoFormattedList = realm?.objects(SunNoFormatted.self) else { return }
            for sun in sunNoFormattedList {
                targetDateTomorrow = sun.sunset.toDate().advanced(by: 0.5 * 60 * 60) // .addingTimeInterval(1.5 * 60 * 60)
            }
            print("targetDateTomorrow in SetAlarm : \(targetDateTomorrow)")
            completion?(title, body, targetDateTomorrow)
        }
        createReminderWithAlert()
    }
    
    private func activateRemind() {
        setAlarm()
        print("reminds array in activeRemindButtonTapped : \(self.reminds)")
    }

    private func cancelRemind() {
        deleteAllReminders()
    }
    
    private func createReminderWithAlert() {
        reminds.removeAll()
        NotificationHelper.removeAllLocalNotification()
        completion = { title, body, date in
            DispatchQueue.main.async {
                let notificationModel = NotificationModel(title: title, message: body, plannedFor: date)
                self.reminds.append(notificationModel)
                NotificationHelper.addLocalNotification(notificationModel)
                self.presentAlert(typeError: .notificationActive)
            }
        }
    }
    
//    private func createReminder() {
//        reminds.removeAll()
//        NotificationHelper.removeAllLocalNotification()
//        completion = { title, body, date in
//            DispatchQueue.main.async {
//                let notificationModel = NotificationModel(title: title, message: body, plannedFor: date)
//                self.reminds.append(notificationModel)
//                self.sunsetSwitch.isOn = true
//                NotificationHelper.addLocalNotification(notificationModel)
//            }
//        }
//    }
    
    private func deleteAllReminders() {
        if reminds.isEmpty {
            print("no scheduled reminder")
            presentAlert(typeError: .noNotification)
        } else {
            reminds.removeAll()
            NotificationHelper.removeAllLocalNotification()
            print("all reminders deleted")
            sunsetSwitch.isOn = false
            presentAlert(typeError: .notificationDeleted)
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
        print("sunsetSwitch.isOn in viewdidload : \(sunsetSwitch.isOn)")
        print("")
        print("My reminders in viewdidload : \(reminds)")
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
    
//    fileprivate func debugRealmReminds() {
//        guard let remindsList = realm?.objects(Reminders.self) else { return }
//        for remind in remindsList {
//            print("remindsList => ")
//            print("remind.reminds - viewDidLoad: \(remind.reminds)")
//            print("")
//        }
//    }
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
