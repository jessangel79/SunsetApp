//
//  Sun.swift
//  SunsetApp
//
//  Created by Angelique Babin on 26/09/2020.
//

import Foundation
import RealmSwift

class Sun: Object {
//    dynamic var id = 0
    @objc dynamic var oldDate = ""
    @objc dynamic var currentDate = ""
    @objc dynamic var sunset = ""
    @objc dynamic var sunrise = ""
    @objc dynamic var dayLength = ""
    
//    override class func primaryKey() -> String? {
//        return "id"
//    }
}
