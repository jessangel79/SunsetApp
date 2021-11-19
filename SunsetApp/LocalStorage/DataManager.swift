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
        guard let sunApiResults = data.sunApiResults else { return }
        sun.sunset = sunApiResults.sunset.transformHour()
        sun.sunrise = sunApiResults.sunrise.transformHour()
        sun.dayLength = sunApiResults.dayLength.convertSecondsInHours()
        sun.sunsetNoFormatted = sunApiResults.sunset
        sun.sunriseNoFormatted = sunApiResults.sunrise
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
}
