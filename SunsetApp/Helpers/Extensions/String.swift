//
//  String.swift
//  SunsetApp
//
//  Created by Angelique Babin on 24/09/2020.
//

import Foundation

extension String {
    
    /// convert am / pm time in 24 hour format
    func date24() -> String {
        let dateAsString = self // "6:35 PM"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm:ss a"
        let date = dateFormatter.date(from: dateAsString)
        dateFormatter.dateFormat = "H:mm:ss"
        let date24 = dateFormatter.string(from: date ?? Date())
        return date24
    }
    
    /// get current date
    func getCurrentDate() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let stringDate = dateFormatter.string(from: currentDate)

        print(currentDate)
        print(stringDate)
        return stringDate
    }
    
    /// delete last characters with string index
//    func cutEndString(stringElementOf: String.Element) -> String {
//        guard let endOfSentence = self.firstIndex(of: stringElementOf) else { return "" }
//        var firstSentence = self[...endOfSentence]
//        firstSentence.removeLast()
//        return String(firstSentence)
//    }
}
