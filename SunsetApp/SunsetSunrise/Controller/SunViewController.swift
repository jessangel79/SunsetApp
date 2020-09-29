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
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var alarmSunsetSwitch: UISwitch!
    @IBOutlet weak var alarmSunriseSwitch: UISwitch!
    @IBOutlet weak var alarmView: UIView!
    
    // MARK: - Properties
    
    private let sunService = SunService()
    private var sunApiResults: ResultsApi?
    private var currentDate = String()
    private var oldDate = String()
    private var sunList: Results<Sun>!
    
    private let realm = try? Realm()

    // MARK: - Actions
    
    @IBAction func refreshButtonTapped(_ sender: UIButton) {
//        getSunsetSunrise()
        setData()
    }
    
    @IBAction func sunsetButtonClicked(_ sender: UISwitch) {
        if alarmSunsetSwitch.isOn {
            sender.setOn(false, animated: true)
            print("sunset is Off")
            
//            deleteDataSun(code: sun.sunset)
            
            setData()
            print("oldDate in sunsetButtonClicked : \(oldDate) - currentDate : \(currentDate)")
            
//            alarmSunsetSwitch.offImage = .actions
        } else {
            sender.setOn(true, animated: true)
            print("sunset is On")

        }
    }
    
    @IBAction func sunriseButtonClicked(_ sender: UISwitch) {
        if alarmSunriseSwitch.isOn {
            sender.setOn(false, animated: true)
            print("sunrise is Off")
        } else {
            sender.setOn(true, animated: true)
            print("sunrise is On")
        }
    }
    
    // MARK: - View Life Cycle

//    fileprivate func setData() {
//        if sunApiResults != nil {
//            if oldDate == currentDate {
//                setDataLabels()
//                displaySunCount()
//            } else {
//                deleteAllDataSun()
//                getSunsetSunrise()
//            }
//        } else {
//            deleteAllDataSun()
//            getSunsetSunrise()
//        }
//    }
    
    fileprivate func setData() {
        if oldDate == currentDate {
            setDataLabels()
            displaySunCount()
        } else {
//            deleteAllDataSun()
            getSunsetSunrise()
        }
//        if sunApiResults == nil {
//            deleteAllDataSun()
//            getSunsetSunrise()
//        } else {
//            setDataLabels()
//            displaySunCount()
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        currentDate = "2020-09-30"
        currentDate = currentDate.getCurrentDate()
        oldDate = getOldDate()
//        oldDate = "2020-09-29"
                
        customUI()
        
        print("oldDate in viewdidload : \(oldDate) - currentDate : \(currentDate)")
        
        setData()
        
        setAlarmSwitch()
        print("REALM : \(Realm.Configuration.defaultConfiguration.fileURL!)")
        
        debugRealm()
    }
    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
    
    // MARK: - Methods
    
    private func customUI() {
        customButton(button: refreshButton, radius: 20, width: 0.8, colorBackground: .systemGroupedBackground, colorBorder: .systemIndigo)
        customView(view: alarmView, radius: 15, width: 2.0, colorBorder: .systemGray4)
        customShadowView(view: alarmView)
        customShadowButton(button: refreshButton)
    }
    
    private func setAlarmSwitch() {
        alarmSunsetSwitch.addTarget(self, action: #selector(stateChanged), for: .valueChanged)
        alarmSunriseSwitch.addTarget(self, action: #selector(stateChanged), for: .valueChanged)
    }
    
    @objc func stateChanged(switchState: UISwitch) {
        if switchState.isOn {
            print("The switch is On")
        } else {
            print("The switch is Off")
        }
    }
    
    private func debugRealm() {
        guard let sunList = realm?.objects(Sun.self) else { return }
        for sun in sunList {
            print("sunset - viewDidLoad: \(sun.sunset)")
            print("sunrise - viewDidLoad: \(sun.sunrise)")
            print("dayLength - viewDidLoad: \(sun.dayLength)")
            print("sun.oldDate - viewDidLoad: \(sun.oldDate)")
            print("sun.currentDate - viewDidLoad: \(sun.currentDate)")
            print("oldDate - viewDidLoad: \(oldDate)")
            print("currentDate - viewDidLoad: \(currentDate)")
        }
    }
    
    private func getOldDate() -> String {
        guard let sunList = realm?.objects(Sun.self) else { return "" }
        var oldDateTemp = ""
        for sun in sunList {
            oldDateTemp = sun.oldDate
        }
        return oldDateTemp
        
//        guard let sunList = realm?.objects(Sun.self) else { return }
//        for sun in sunList {
//            let sunset = sun.sunset
//            let sunrise = sun.sunrise
//            let dayLength = sun.dayLength
    }
    
    private func getSunsetSunrise() {
//        if currentDate == oldDate {
//            setDataLabels()
//            displaySunCount()
//        } else {
            deleteAllDataSun()
            sunService.getSunsetSunrise(currentDate: currentDate) { (success, sunApi) in
                self.toggleActivityIndicator(shown: false,
                                             activityIndicator: self.activityIndicator,
                                             validateButton: self.refreshButton)
                if success {
                    guard let sunApi = sunApi else { return }
                    if sunApi.status == "OK" {
                        self.sunApiResults = sunApi.results
                        self.setLabels()
                        self.saveDataSun()
                        self.displaySunCount()
                    } else {
                        self.presentAlert(typeError: .error)
                        self.toggleActivityIndicator(shown: false,
                                                     activityIndicator: self.activityIndicator,
                                                     validateButton: self.refreshButton)
                    }
                } else {
                    self.presentAlert(typeError: .error)
                    self.toggleActivityIndicator(shown: false,
                                                 activityIndicator: self.activityIndicator,
                                                 validateButton: self.refreshButton)
                }
            }
//        }
    }
    
    private func setLabels() {
        print("sunset.date24 : \(String(describing: sunApiResults?.sunset.date24()))")
        print("sunrise : \(String(describing: sunApiResults?.sunrise.date24()))")
        print("dayLength : \(String(describing: sunApiResults?.dayLength))")
        
        sunsetLabel.text = sunApiResults?.sunset.date24()
        sunriseLabel.text = sunApiResults?.sunrise.date24()
        dayLengthLabel.text = sunApiResults?.dayLength
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
            print("sunset : \(sunset)")
            print("sunrise : \(sunrise)")
            print("dayLength : \(dayLength)")
            print("currentDate : \(currentDate)")
            print("oldDate : \(oldDate)")

        }
    }
    
    private func displaySunCount() {
        let sunList = realm?.objects(Sun.self)
        print("il y a \(String(describing: sunList?.count)) Sun dans la liste")
    }
    
    private func saveDataSun() {
        let sun = Sun()
        sun.sunset = sunApiResults?.sunset.date24() ?? ""
        sun.sunrise = sunApiResults?.sunrise.date24() ?? ""
        sun.dayLength = sunApiResults?.dayLength ?? ""
        sun.currentDate = currentDate
        sun.oldDate = currentDate
        oldDate = currentDate

        do {
            try realm?.write {
                realm?.add(sun)
            }
            print("object saved - sunset : \(sun.sunset)")
            print("object saved - sunrise : \(sun.sunrise)")
            print("object saved - oldDate : \(sun.oldDate)")
            print("object saved - currentDate : \(sun.currentDate)")
            print("object - currentDate : \(currentDate)")
            print("object - oldDate : \(oldDate)")

        } catch let error as NSError {
            print(error.localizedDescription)
        }

        // other method to write with realm
//        realm?.beginWrite()
//        realm?.add(sun)
//        try! realm?.commitWrite()
        
        // delete an object
//        try? realm?.write {
//            realm?.delete(sun)
//        }
    }
    
//    private func updateDataSun() {
////        let sun = Sun()
////        sun.sunset = sunApiResults?.sunset ?? ""
////        sun.sunrise = sunApiResults?.sunrise ?? ""
////        sun.dayLength = sunApiResults?.dayLength ?? ""
////        sun.oldDate = currentDate
//
//        do {
//            try realm?.write {
////                realm?.add(sun)
//                oldDate = currentDate
//            }
////            print("object saved - sunset : \(sun.sunset)")
////            print("object saved - sunrise : \(sun.sunrise)")
////            print("object saved - oldDate : \(sun.oldDate)")
//            print("object saved - currentDate : \(currentDate)")
//
//        } catch let error as NSError {
//            print(error.localizedDescription)
//        }
//
//        // other method to write with realm
////        realm?.beginWrite()
////        realm?.add(sun)
////        try! realm?.commitWrite()
//
//        // delete an object
////        try? realm?.write {
////            realm?.delete(sun)
////        }
//    }

    private func deleteAllDataSun() {
        realm?.beginWrite()
        realm?.delete((realm?.objects(Sun.self))!)
        try? realm?.commitWrite()
//        do {
//            try realm?.write {
//                realm?.deleteAll()
//            }
//        } catch let error as NSError {
//            print("error : \(error.localizedDescription)")
//        }
        
//        do {
//            let objects = (realm?.objects(Sun.self))!
//            try realm?.write {
//                realm?.delete(objects)
//            }
//        } catch let error as NSError {
//            print("error : \(error.localizedDescription)")
//        }
    }
    
    private func deleteDataSun() { // code: String
        do {
            let sunList = (realm?.objects(Sun.self))!
            try realm?.write {
                realm?.delete(sunList)
            }
            displaySunCount()
        } catch let error as NSError {
            print("error : \(error.localizedDescription)")
        }
//        do {
////            let object = realm?.objects(Sun.self).filter("sunset = %@", code).first
//            let object = realm?.objects(Sun.self).first
//            try realm?.write {
//                if let obj = object {
//                    realm?.delete(obj)
//                }
//            }
//        } catch let error as NSError {
//            print("error : \(error.localizedDescription)")
//        }
    }
}
