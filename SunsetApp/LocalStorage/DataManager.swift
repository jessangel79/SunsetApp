//
//  DataManager.swift
//  SunsetApp
//
//  Created by Angelique Babin on 29/09/2020.
//

import Foundation
import RealmSwift

final class DataManager {
    
    func saveDataSun(data: StructDataManager, oldDateNoFormatted: inout String) {
        let sun = Sun()
        //        guard let sunset = data.sunApiResults?.sunset.transformHour() else { return }
        //        guard let sunrise = data.sunApiResults?.sunrise.transformHour() else { return }
        //        guard let dayLength = data.sunApiResults?.dayLength.convertSecondsInHours() else { return }
        //        guard let sunsetNoFormatted = data.sunApiResults?.sunset else { return }
        //        guard let sunriseNoFormatted =  data.sunApiResults?.sunrise else { return }
        //        sun.sunset = sunset
        //        sun.sunrise = sunrise
        //        sun.dayLength = dayLength
        //        sun.sunsetNoFormatted = sunsetNoFormatted
        //        sun.sunriseNoFormatted = sunriseNoFormatted
        sun.sunset = data.sunApiResults?.sunset.transformHour() ?? ""
        sun.sunrise = data.sunApiResults?.sunrise.transformHour() ?? ""
        sun.dayLength = data.sunApiResults?.dayLength.convertSecondsInHours() ?? ""
        sun.sunsetNoFormatted = data.sunApiResults?.sunset ?? ""
        sun.sunriseNoFormatted = data.sunApiResults?.sunrise ?? ""
        sun.currentDate = data.currentDate
        sun.oldDate = data.currentDate
        sun.tomorrowDate = data.tomorrowDate
        oldDateNoFormatted = data.currentDate
        do {
            try data.realm?.write {
                data.realm?.add(sun)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func deleteAllDataSun(realm: Realm?) {
        realm?.beginWrite()
        realm?.delete((realm?.objects(Sun.self))!)
        try? realm?.commitWrite()
    }

//    func deleteDataSun(realm: Realm?) {
//        do {
//            let sunList = (realm?.objects(Sun.self))!
//            try realm?.write {
//                realm?.delete(sunList)
//            }
//            displaySunCount(realm: realm)
//        } catch let error as NSError {
//            print("error : \(error.localizedDescription)")
//        }
//    }
    
    // debug
    func displaySunCount(realm: Realm?) {
        let sunList = realm?.objects(Sun.self)
        print("il y a \(String(describing: sunList?.count)) Sun dans la liste")
    }
}
