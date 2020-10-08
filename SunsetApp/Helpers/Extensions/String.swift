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
//    func date24() -> String {
//        let dateAsString = self // "6:35 PM"
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "h:mm:ss a"
//        let date = dateFormatter.date(from: dateAsString)
//        dateFormatter.dateFormat = "H:mm:ss"
//        let date24 = dateFormatter.string(from: date ?? Date())
//        return date24
//    }
    
    /// convert am / pm time in 24 hour format
    func dateFormat() -> String {
        let dateAsString = self // 2020-10-08
        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "h:mm:ss"
        let date = dateFormatter.date(from: dateAsString)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateFormat = dateFormatter.string(from: date ?? Date())
        return dateFormat
    }
    
    /// transform date no formatted in hour, minute and second
    func transformDateInHour() -> String {
        var dateTemp = ""
        let initialString = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        
        if let date = dateFormatter.date(from: initialString) {
            let calendar = Calendar.current
            let dateComponents = calendar.dateComponents([.hour, .minute, .second], from: date)
            dateTemp = "\(dateComponents.hour ?? 0):\(dateComponents.minute ?? 0):\(dateComponents.second ?? 0)"
//            let dateTempAsDate = dateTemp.toDate()
//            dateTemp = dateTempAsDate.toString(format: "H:mm:ss")
//            print("\(dateComponents.hour ?? 0):\(dateComponents.minute ?? 0):\(dateComponents.second ?? 0)") // 11:45:00
        }
        return dateTemp
    }
    
    /// transform date no formatted in date formatted
    func transformDate() -> String {
        var dateTemp = ""
        let initialString = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ" // FormatDate.formatted.rawValue
        
        if let date = dateFormatter.date(from: initialString) {
            let calendar = Calendar.current
            let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
            dateTemp = "\(dateComponents.year ?? 0)-\(dateComponents.month ?? 0)-\(dateComponents.day ?? 0)"
//            print("\(dateComponents.year ?? 0)-\(dateComponents.month ?? 0)-\(dateComponents.day ?? 0)") // 2020-10-02
        }
        return dateTemp
    }
    
    func transformHour() -> String {
        var hourTemp = self.transformDateInHour()
        let hourTempInDate = self.toDate()
        hourTemp = hourTempInDate.toString(format: "H:mm:ss")
        return hourTemp
//        let dateTempInDate = dateTemp.toDate()
//        dateTemp = dateTempInDate.toString(format: "H:mm:ss")
    }
    
    /// get current date
    func getCurrentDate(dateFormat: String) -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let stringDate = dateFormatter.string(from: currentDate)
        return stringDate
    }
    
    /// get old date
    func getOldDate(sunList: Results<SunNoFormatted>) -> String {
        var oldDateTemp = ""
        for sun in sunList {
            oldDateTemp = sun.oldDate.transformDate()
            let oldDateInDate = oldDateTemp.toDate()
            oldDateTemp = oldDateInDate.toString(format: "yyyy-MM-dd")
        }
//        print("oldDateTemp in getOldDate : \(oldDateTemp)")
        return oldDateTemp
    }
    
    /// get old date no formatted
//    func getOldDateNoFormatted(sunNoFormattedList: Results<SunNoFormatted>) -> String {
//        var oldDateTemp = ""
//        for sun in sunNoFormattedList {
//            oldDateTemp = sun.oldDate
//        }
//        return oldDateTemp
//    }
    
    /// format type string in type date
    func toDate(format: String = FormatDate.noFormatted.rawValue) -> Date { // 2020-09-30 15:32:00 +0000 // "1996-12-19T16:39:57-08:00"
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self) ?? Date()
    }
}
