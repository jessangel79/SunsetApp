//
//  Int.swift
//  SunsetApp
//
//  Created by Angelique Babin on 08/10/2020.
//

import Foundation

extension Int {
    
    /// convert seconds in hours
    func convertSecondsInHours() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        guard let formattedString = formatter.string(from: TimeInterval(self)) else { return "" }
//        print(formattedString)
        return formattedString
    }
}
