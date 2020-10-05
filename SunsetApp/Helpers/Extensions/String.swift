//
//  String.swift
//  SunsetApp
//
//  Created by Angelique Babin on 24/09/2020.
//

import Foundation
import RealmSwift

extension String {
    
    /// convert am / pm time in 24 hour format
    func date24(typeHour: Double) -> String {
        let dateAsString = self // "6:35 PM"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm:ss a"
        let date = dateFormatter.date(from: dateAsString)?.addingTimeInterval(typeHour * 60 * 60)
        dateFormatter.dateFormat = "H:mm:ss"
        let date24 = dateFormatter.string(from: date ?? Date())
        return date24
    }
    
    /// get current date
    func getCurrentDate(dateFormat: String) -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let stringDate = dateFormatter.string(from: currentDate)
//        print(currentDate)
//        print(stringDate)
        return stringDate
    }
    
    /// get old date
    func getOldDate(sunList: Results<Sun>) -> String {
        var oldDateTemp = ""
        for sun in sunList {
            oldDateTemp = sun.oldDate
        }
        return oldDateTemp
    }
    
    /// get old date no formatted
    func getOldDateNoFormatted(sunNoFormattedList: Results<SunNoFormatted>) -> String {
        var oldDateTemp = ""
        for sun in sunNoFormattedList {
            oldDateTemp = sun.oldDate
        }
        return oldDateTemp
    }
    
    /// format type string in type date
    func toDate(format: String = FormatDate.noFormatted.rawValue) -> Date { // 2020-09-30 15:32:00 +0000 // "1996-12-19T16:39:57-08:00"
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        // test
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 2 * 60 * 60)
        
        return formatter.date(from: self) ?? Date()
    }
}
