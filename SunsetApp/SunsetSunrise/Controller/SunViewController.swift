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
    private var sunApiResults: Results?
    private var currentDate = String()

    // MARK: - Actions
    
    @IBAction func refreshButtonTapped(_ sender: UIButton) {
        getSunsetSunrise()
        
        // test
        saveDataSun()
        displaySunCount()
    }
    
    @IBAction func sunsetButtonClicked(_ sender: UISwitch) {
        if alarmSunsetSwitch.isOn {
            sender.setOn(false, animated: true)
            print("sunset is Off")
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

    override func viewDidLoad() {
        super.viewDidLoad()
        currentDate = currentDate.getCurrentDate()
        customUI()
        getSunsetSunrise()
        setAlarmSwitch()
        saveDataSun()
        displaySunCount()
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
    
    private func getSunsetSunrise() {
        sunService.getSunsetSunrise(currentDate: currentDate) { (success, sunApi) in
            self.toggleActivityIndicator(shown: false,
                                         activityIndicator: self.activityIndicator,
                                         validateButton: self.refreshButton)
            if success {
                guard let sunApi = sunApi else { return }
                if sunApi.status == "OK" {
                    self.sunApiResults = sunApi.results
                    self.setLabels()
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
    }
    
    private func setLabels() {
        print("sunset.date24 : \(String(describing: sunApiResults?.sunset.date24()))")
        print("sunrise : \(String(describing: sunApiResults?.sunrise.date24()))")
        print("dayLength : \(String(describing: sunApiResults?.dayLength))")

        sunsetLabel.text = sunApiResults?.sunset.date24()
        sunriseLabel.text = sunApiResults?.sunrise.date24()
        dayLengthLabel.text = sunApiResults?.dayLength
    }
    
    private func saveDataSun() {
        let sun = Sun()
        sun.sunset = sunApiResults?.sunset ?? ""
        sun.sunrise = sunApiResults?.sunrise ?? ""
        sun.dayLength = sunApiResults?.dayLength ?? ""
        sun.currentDate = currentDate
        
        let realm = try? Realm()
        try? realm?.write {
            realm?.add(sun)
        }
    }
    
    private func displaySunCount() {
        let realm = try? Realm()
        let sunList = realm?.objects(Sun.self)
        guard let sunListCount = sunList?.count else { return }
        print("il y a \(sunListCount) Sun dans la liste")
    }
}
