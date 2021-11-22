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
            guard let value = UserDefaults.standard.object(forKey: key) as? DataType else { return defaultValue }
            return value
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

struct UserSettings {
    
    @MyUserDefaults(key: "segmentedTypeDay", defaultValue: 0)
    static var segmentedTypeDay: Int

    @MyUserDefaults(key: "isNotificationIsActivated", defaultValue: false)
    static var isNotificationIsActivated: Bool
    
}
