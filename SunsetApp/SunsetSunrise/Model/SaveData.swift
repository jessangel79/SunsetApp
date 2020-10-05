//
//  SaveData.swift
//  SunsetApp
//
//  Created by Angelique Babin on 29/09/2020.
//

import Foundation

final class DataManager {
    
    func saveDataSun(data: StructData, oldDate: inout String) {
        let sun = Sun()
        sun.sunset = data.sunApiResults?.sunset.date24() ?? ""
        sun.sunrise = data.sunApiResults?.sunrise.date24() ?? ""
        sun.dayLength = data.sunApiResults?.dayLength ?? ""
        sun.currentDate = data.currentDate
        sun.oldDate = data.currentDate
        oldDate = data.currentDate
        do {
            try data.realm?.write {
                data.realm?.add(sun)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
