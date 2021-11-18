//
//  String.swift
//  SunsetApp
//
//  Created by Angelique Babin on 24/09/2020.
//

import Foundation
import RealmSwift

extension String {
    
    func transformToDouble() -> Double {
        guard let strInDouble = Double(self) else { return Double() }
        return strInDouble
    }
    
    /// transform date in hour
    func transformHour() -> String {
        let hourTempInDate = self.toDate()
        let hourTemp = hourTempInDate.toString(format: "H:mm:ss")
        return hourTemp
    }
    
    /// transform date no formatted in date formatted
    func transformDate() -> String {
        var dateTemp = ""
        let initialString = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        
        if let date = dateFormatter.date(from: initialString) {
            let calendar = Calendar.current
            let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
            
            guard let year = dateComponents.year else { return "" }
            guard let month = dateComponents.month else { return "" }
            guard let day = dateComponents.day else { return "" }
            dateTemp = "\(year)-\(month)-\(day)"
//            dateTemp = "\(dateComponents.year ?? 0)-\(dateComponents.month ?? 0)-\(dateComponents.day ?? 0)"
        }
        return dateTemp
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
    func getOldDate(sunList: Results<Sun>) -> String {
        var oldDateTemp = ""
        for sun in sunList {
            oldDateTemp = sun.oldDate.transformDate()
            let oldDateInDate = oldDateTemp.toDate()
            oldDateTemp = oldDateInDate.toString(format: "yyyy-MM-dd")
        }
        return oldDateTemp
    }
    
    /// get old date Test
    func getOldDateTest(sunList: Results<Sun>, format: String) -> String {
        var oldDateTemp = ""
        for sun in sunList {
            oldDateTemp = sun.oldDate
            let oldDateInDate = oldDateTemp.toDate()
            oldDateTemp = oldDateInDate.toString(format: format)
        }
        return oldDateTemp
    }
    
    /// format type string in type date
    func toDate(format: String = "yyyy-MM-dd'T'HH:mm:ssZZZZZ") -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self) ?? Date()
    }
}
