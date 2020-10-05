//
//  Date.swift
//  SunsetApp
//
//  Created by Angelique Babin on 02/10/2020.
//

import Foundation

extension Date {
    
    /// format type date in type string
    func toString(format: String) -> String { // or "dd-MM-yyyy"
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
