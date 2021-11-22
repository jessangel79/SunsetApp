//
//  SunViewController.swift
//  SunsetApp
//
//  Created by Angelique Babin on 24/09/2020.
//

import UIKit
import RealmSwift
import UserNotifications
import CoreLocation
import SwiftyGif
import GoogleMobileAds

final class SunViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var sunsetLabel: UILabel!
    @IBOutlet private weak var sunriseLabel: UILabel!
    @IBOutlet private weak var dayLengthLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var choiceDaySegmentedControl: UISegmentedControl!
    @IBOutlet private weak var currentDateLabel: UILabel!
    @IBOutlet private weak var dayLabel: UILabel!
    @IBOutlet private weak var baseView: UIView!
    @IBOutlet private weak var activeSunsetView: UIView!
    @IBOutlet private weak var activeNotificationButton: UIButton!
    @IBOutlet private weak var bannerView: GADBannerView!
    
    // MARK: - Properties
    
    private var sunApiResults: ResultsApi?
    private var currentDate = String()
    private var tomorrowDate = String()
    private var oldDate = String()
    private var currentDateNoFormatted = String()
    private var tomorrowDateNoFormatted = String()
    private var oldDateNoFormatted = String()
    private let realm = try? Realm()
    private var tomorrowInDate = Date()
    private var tomorrowNoFormattedInDate = Date()
    private var isNotificationIsActivated = false
    private var completion: ((String, String, Date) -> Void)?
    private var reminds: [NotificationModel] = [NotificationModel]()
    private let adMobService = AdMobService()
    private let locationManager = CLLocationManager()
    private var userPosition: CLLocation?
    private var latitude: Double?
    private var longitude: Double?
    private var coordinateInit: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(
            latitude: latitude ?? Cst.CoordinatesInit.latitudeInit.transformToDouble(),
            longitude: longitude ?? Cst.CoordinatesInit.longitudeInit.transformToDouble())
    }
    
    // MARK: - Actions
    
    @IBAction private func refreshBarButtonItemTapped(_ sender: UIBarButtonItem) {
        refresh()
    }
    
    @IBAction private func activeNotificationButtonTapped(_ sender: UIButton) {
        locationManager.requestLocation()
        activateRemind()
    }
    
    @IBAction private func cancelNotificationTapped(_ sender: UIButton) {
        cancelRemind()
    }
    
    @IBAction private func typeDaySelected(_ sender: UISegmentedControl) {
        locationManager.requestLocation()
        UserSettings.segmentedTypeDay = choiceDaySegmentedControl.selectedSegmentIndex
        switch sender.selectedSegmentIndex {
        case 0:
            getSunsetSunriseNoFormatted(date: currentDate)
        default:
            getSunsetSunriseNoFormatted(date: tomorrowDate)
        }
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customUI()
        loadUserDefaults()
        setupLocationManager()
        locateUser()
        adMobService.setAdMob(bannerView, self)
        NotificationHelper.removeAllLocalNotificationDelivered()
        reminds = [NotificationModel]()
        getDates()
        setData()
        setAlarm()
//        print("REALM : \(Realm.Configuration.defaultConfiguration.fileURL!)") // for db Realm Studio
//        debug()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadUserDefaults()
    }
    
    // MARK: - Methods
    
    private func customUI() {
        customView(view: baseView, radius: 15, width: 2.0, colorBorder: .systemGray4)
        customShadowView(view: baseView)
        customView(view: activeSunsetView, radius: 10, width: 2.0, colorBorder: .systemGray4)
        customShadowView(view: activeSunsetView)
    }
    
    private func loadUserDefaults() {
        let myTypeDay = UserSettings.segmentedTypeDay
        choiceDaySegmentedControl.selectedSegmentIndex = myTypeDay
    }
    
    private func refresh() {
        locationManager.requestLocation()
        locateUser()
        getDates()
        setData()
        presentAlert(typeError: .updateData)
        UIApplication.shared.applicationIconBadgeNumber = 0
        stopGif()
    }
    
    private func stopGif() {
        activeNotificationButton.imageView?.stopAnimatingGif()
        activeNotificationButton.imageView?.currentImage = UIImage(named: Cst.Img.active)
    }
    
    private func getDates() {
        getDatesFormatted()
        getDatesNoFormatted()
        setTomorrowDates()
    }
    
    private func getDatesFormatted() {
        currentDate = currentDate.getCurrentDate(dateFormat: FormatDate.formatted.rawValue)
        guard let sunList = realm?.objects(Sun.self) else { return }
        oldDate = oldDate.getOldDate(sunList: sunList, format: FormatDate.formatted.rawValue)

    }
    
    private func getDatesNoFormatted() {
        currentDateNoFormatted = currentDateNoFormatted.getCurrentDate(dateFormat: FormatDate.noFormatted.rawValue)
        guard let sunList = realm?.objects(Sun.self) else { return }
        oldDateNoFormatted = oldDateNoFormatted.getOldDate(sunList: sunList, format: FormatDate.noFormatted.rawValue)

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
            if choiceDaySegmentedControl.selectedSegmentIndex == 0 {
                getSunsetSunriseNoFormatted(date: currentDate)
            } else {
                getSunsetSunriseNoFormatted(date: tomorrowDate)
            }
        }
        debugGetDateNoFormatted()
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
    
    private func getSunsetSunriseNoFormatted(date: String) {
        locateUser()
        let dataManager = DataManager()
        dataManager.deleteAllDataSun(realm: realm)
        let sunService = SunService()
        let lat = coordinateInit.latitude.description
        let long = coordinateInit.longitude.description
        sunService.getSunsetSunrise(date: date, lat: lat, long: long) { (success, sunApi) in
            self.toggleActivityIndicator(shown: false,
                                         activityIndicator: self.activityIndicator,
                                         view: self.baseView)
            if success {
                guard let sunApi = sunApi else { return }
                if sunApi.status == "OK" {
                    self.sunApiResults = sunApi.results
                    self.setLabels()
                    let data = StructDataManager(sunApiResults: self.sunApiResults,
                                                 currentDate: self.currentDateNoFormatted,
                                                 tomorrowDate: self.tomorrowDateNoFormatted,
                                                 realm: self.realm)
                    dataManager.saveDataSun(data: data, oldDateNoFormatted: &self.oldDateNoFormatted)
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
    
    private func setLabels() {
        sunsetLabel.text = sunApiResults?.sunset.transformHour()
        sunriseLabel.text = sunApiResults?.sunrise.transformHour()
        dayLengthLabel.text = sunApiResults?.dayLength.convertSecondsInHours()
        setDayLabel()
    }
    
    private func setDayLabel() {
        if choiceDaySegmentedControl.selectedSegmentIndex == 0 {
            dayLabel.text = FormatDate.today.rawValue
            currentDateLabel.text = currentDate.getCurrentDate(dateFormat: FormatDate.toDisplay.rawValue)
        } else {
            dayLabel.text = FormatDate.tomorrow.rawValue
            currentDateLabel.text = tomorrowInDate.toString(format: FormatDate.toDisplay.rawValue)
        }
    }

}

// MARK: - Reminder

extension SunViewController {
    
    private func activateRemind() {
        setAlarm()
        UIApplication.shared.applicationIconBadgeNumber = 0
        stopGif()
    }
    
    private func setAlarm() {
        let title = "Bye Bye Sun !"
        let body = "The sun has set. The shutters must be closed !!!"
        guard let sunNoFormattedList = self.realm?.objects(Sun.self) else { return }
        var date = Date() // .addingTimeInterval(12) //-- To test --// Date()
        for sun in sunNoFormattedList {
            date = sun.sunsetNoFormatted.toDate()
        }
        print("sun.sunsetNoFormatted.toDate() in setAlarm => \(date)")
        completion?(title, body, date)
        createReminder()
    }
        
    private func createReminder() {
        reminds.removeAll()
        NotificationHelper.removeAllLocalNotification()
        completion = { title, body, date in
            DispatchQueue.main.async {
                let notificationModel = NotificationModel(title: title, message: body, plannedFor: date)
                self.reminds.append(notificationModel)
                NotificationHelper.requestAuthorization(notificationModel, date)
                self.isNotificationIsActivated = true
                self.presentAlert(typeError: .notificationActive)
            }
            self.alertUserIfIncorrectDate(date)
        }
    }
    
    private func alertUserIfIncorrectDate(_ date: Date) {
        if !date.checkDate() {
            let actionToTomorrow = UIAlertAction(title: "Ok", style: .default) { action in
                self.choiceDaySegmentedControl.selectedSegmentIndex = 1
                UserSettings.segmentedTypeDay = self.choiceDaySegmentedControl.selectedSegmentIndex
                self.getSunsetSunriseNoFormatted(date: self.tomorrowDate)
                guard let gif = try? UIImage(gifName: Cst.Img.activeGif) else { return }
                self.activeNotificationButton.imageView?.setGifImage(gif, loopCount: -1)
                self.activeNotificationButton.imageView?.startAnimatingGif()
            }
            showAlertAction(action: actionToTomorrow)
        }
    }
    
    private func cancelRemind() {
        if ![UNUserNotificationCenter.getPendingNotificationRequests].isEmpty && isNotificationIsActivated {
            deleteAllReminders()
        } else {
            presentAlert(typeError: .noNotification)
        }
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    private func deleteAllReminders() {
        reminds.removeAll()
        NotificationHelper.removeAllLocalNotification()
        isNotificationIsActivated = false
        presentAlert(typeError: .notificationDeleted)
        print("all reminders deleted")
    }
}

// MARK: - Extension CLLocationManagerDelegate

extension SunViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            if let myPosition = locations.last {
                userPosition = myPosition
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied {
            manager.stopUpdatingLocation()
            return
        }
        presentAlert(typeError: .error)
    }

    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        authorizationStatusAccessLocation()
    }

    private func authorizationStatusAccessLocation() {
        switch CLLocationManager.authorizationStatus() {
        case .denied, .restricted:
            presentAlert(typeError: .authorizationStatusLocationDenied)
        case .authorizedAlways, .authorizedWhenInUse:
            locateUser()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            locationManager.requestWhenInUseAuthorization()
        }
    }

    private func locateUser() {
        guard let userPositionCoordinate = userPosition?.coordinate else { return }
        latitude = userPositionCoordinate.latitude
        longitude = userPositionCoordinate.longitude
    }
}

// MARK: - Debug

extension SunViewController {
    
    private func debug() {
        debugViewDidLoad()
        debugRealmSun()
    }
    
    private func debugViewDidLoad() {
        print("")
        print("oldDate in viewdidload : \(oldDate) - currentDate : \(currentDate)")
        print("oldDateNoFormatted in viewdidload : \(oldDateNoFormatted) - currentDateNoFormatted : \(currentDateNoFormatted)")
        print("tomorrowDate in viewdidload : \(tomorrowDate) - tomorrowDateNoFormatted : \(tomorrowDateNoFormatted)")
        print("")
        print("coordinates?.latitude : \(String(describing: userPosition?.coordinate.latitude))")
        print("coordinates?.longitude : \(String(describing: userPosition?.coordinate.longitude))")
        print("")
        print("My reminders in viewdidload : \(reminds)")
        print("")
    }
    
    private func debugSetDataLabels(_ sunset: String, _ sunrise: String, _ dayLength: String, _ sun: Sun) {
        print("In setDataLabels --- Sun => ")
        print("sunset : \(sunset)")
        print("sunrise : \(sunrise)")
        print("dayLength : \(dayLength)")
        print("currentDate : \(currentDate)")
        print("oldDate : \(oldDate)")
        print("tomorrowDate : \(tomorrowDate)")
        print("latitude : \(String(describing: coordinateInit.latitude))")
        print("longitude : \(String(describing: coordinateInit.longitude))")
        print("")
    }
    
    private func debugGetDateNoFormatted() {
        guard let sunList = realm?.objects(Sun.self) else { return }
        for sun in sunList {
            let sunset = sun.sunset
            let sunrise = sun.sunrise
            let dayLength = sun.dayLength
            print("In getDateNoFormatted --- Sun with dates not formatted => ")
            print("sunset : \(sunset)")
            print("sunrise : \(sunrise)")
            print("dayLength : \(dayLength)")
            print("currentDate : \(currentDate)")
            print("oldDate : \(oldDate)")
            print("currentDateNoFormatted : \(currentDateNoFormatted)")
            print("oldDateNoFormatted : \(oldDateNoFormatted)")
            print("tomorrowDate : \(tomorrowDateNoFormatted)")
            print("")
        }
    }
    
    private func debugRealmSun() {
        guard let sunList = realm?.objects(Sun.self) else { return }
        for sun in sunList {
            print("Sun with dates not formatted => ")
            print("sunset - viewDidLoad: \(sun.sunset)")
            print("sunrise - viewDidLoad: \(sun.sunrise)")
            print("sunsetNoFormatted - viewDidLoad: \(sun.sunsetNoFormatted)")
            print("sunriseNoFormatted - viewDidLoad: \(sun.sunriseNoFormatted)")
            print("dayLength - viewDidLoad: \(sun.dayLength)")
            print("sun.oldDate - viewDidLoad: \(sun.oldDate)")
            print("sun.currentDate - viewDidLoad: \(sun.currentDate)")
            print("sun.tomorrowDate - viewDidLoad: \(sun.tomorrowDate)")
            print("oldDate - viewDidLoad: \(oldDate)")
            print("currentDate - viewDidLoad: \(currentDate)")
            print("tomorrowDate - viewDidLoad: \(tomorrowDate)")
            print("")
        }
    }
}
