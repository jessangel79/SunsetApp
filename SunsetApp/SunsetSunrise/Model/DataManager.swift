//
//  DataManager.swift
//  SunsetApp
//
//  Created by Angelique Babin on 29/09/2020.
//

import Foundation
import RealmSwift

final class DataManager {
    
//    func saveDataSun(data: StructDataManager, oldDate: inout String, typeHour: Double) {
//        let sun = Sun()
//        sun.sunset = data.sunApiResults?.sunset.date24(typeHour: typeHour) ?? ""
//        sun.sunrise = data.sunApiResults?.sunrise.date24(typeHour: typeHour) ?? ""
//        print("sun.sunset in datamanager \(sun.sunset)")
//        print("sun.sunrise in datamanager \(sun.sunrise)")
//        sun.dayLength = data.sunApiResults?.dayLength ?? ""
//        sun.currentDate = data.currentDate
//        sun.oldDate = data.currentDate
//        sun.tomorrowDate = data.tomorrowDate
//        sun.typeHour = typeHour
//        oldDate = data.currentDate
//        do {
//            try data.realm?.write {
//                data.realm?.add(sun)
//            }
//        } catch let error as NSError {
//            print(error.localizedDescription)
//        }
//    }
    
    func saveDataSunNoFormatted(data: StructDataManagerNoFormatted, oldDateNoFormatted: inout String) {
        let sunNoFormatted = SunNoFormatted()
        sunNoFormatted.sunset = data.sunApiResultsNoFormatted?.sunset.transformHour() ?? ""
        sunNoFormatted.sunrise = data.sunApiResultsNoFormatted?.sunrise.transformHour() ?? ""
        sunNoFormatted.dayLength = data.sunApiResultsNoFormatted?.dayLength.convertSecondsInHours() ?? ""
        sunNoFormatted.currentDate = data.currentDate
        sunNoFormatted.oldDate = data.currentDate
        sunNoFormatted.tomorrowDate = data.tomorrowDate
        oldDateNoFormatted = data.currentDate
        do {
            try data.realm?.write {
                data.realm?.add(sunNoFormatted)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func deleteAllDataSun(realm: Realm?) {
        realm?.beginWrite()
        realm?.delete((realm?.objects(SunNoFormatted.self))!)
        try? realm?.commitWrite()
    }
    
//    func deleteAllDataSunNoFormatted(realm: Realm?) {
//        realm?.beginWrite()
//        realm?.delete((realm?.objects(SunNoFormatted.self))!)
//        try? realm?.commitWrite()
//    }
    
    func deleteDataSun(realm: Realm?) {
        do {
            let sunList = (realm?.objects(SunNoFormatted.self))!
            try realm?.write {
                realm?.delete(sunList)
            }
            displaySunCount(realm: realm)
        } catch let error as NSError {
            print("error : \(error.localizedDescription)")
        }
    }

    // debug
    func displaySunCount(realm: Realm?) {
        let sunList = realm?.objects(SunNoFormatted.self)
        print("il y a \(String(describing: sunList?.count)) Sun dans la liste")
    }
}
