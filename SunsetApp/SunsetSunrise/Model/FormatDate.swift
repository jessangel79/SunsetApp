//
//  FormatDate.swift
//  SunsetApp
//
//  Created by Angelique Babin on 02/10/2020.
//

import Foundation

enum FormatDate: String {
    case formatted = "yyyy-MM-dd"
    case noFormatted = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    case toDisplay = "dd/MM/yyyy"
    case today = "Today"
    case tomorrow = "Tomorrow"
}
