//
//  UserSettings.swift
//  SunsetApp
//
//  Created by Angelique Babin on 01/10/2020.
//

import UIKit

@propertyWrapper
struct MyUserDefaults<DataType> {
    let key: String
    let defaultValue: DataType
    var wrappedValue: DataType {
        get {
            return UserDefaults.standard.object(forKey: key) as? DataType
                   ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

struct UserSettings {
    
    @MyUserDefaults(key: "segmentedTypeDay", defaultValue: 0)
    static var segmentedTypeDay: Int
    
    @MyUserDefaults(key: "stateSunsetSwitch", defaultValue: false)
    static var stateSunsetSwitch: Bool
    
//    static var segmentedTypeDay: Int {
//        get {
//            return UserDefaults.standard.object(forKey: "SegmentedTypeDay") as? Int ?? 0
//        }
//        set {
//            UserDefaults.standard.set(newValue, forKey: "SegmentedTypeDay")
//        }
//    }

//    static var stateSunsetSwitch: Bool {
//        get {
//            return UserDefaults.standard.object(forKey: "StateSunsetSwitch") as? Bool ?? false
//        }
//        set {
//            UserDefaults.standard.set(newValue, forKey: "StateSunsetSwitch")
//        }
//    }
    
    // example
//    static var backColor:UIColor {
//        get {
//            return UserDefaults.standard.colorForKey(key:  "BackColor") ?? .blue
//        }
//        set {
//            UserDefaults.standard.setColor(color: newValue, forKey: "BackColor")
//        }
//    }
}
