//
//  Sun.swift
//  SunsetApp
//
//  Created by Angelique Babin on 01/10/2020.
//

import Foundation
import RealmSwift

class Sun: Object {
    @objc dynamic var oldDate = ""
    @objc dynamic var currentDate = ""
    @objc dynamic var sunset = ""
    @objc dynamic var sunrise = ""
    @objc dynamic var sunsetNoFormatted = ""
    @objc dynamic var sunriseNoFormatted = ""
    @objc dynamic var dayLength = ""
    @objc dynamic var tomorrowDate = ""
}
