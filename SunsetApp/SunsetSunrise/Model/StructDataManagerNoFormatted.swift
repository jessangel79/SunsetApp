//
//  StructDataManagerNoFormatted.swift
//  SunsetApp
//
//  Created by Angelique Babin on 01/10/2020.
//

import Foundation
import RealmSwift

struct StructDataManagerNoFormatted {
    let sunApiResultsNoFormatted: ResultsNoFormattedApi?
    let currentDate: String
    let tomorrowDate: String
    let realm: Realm?
}
