//
//  AppDelegate.swift
//  SunsetApp
//
//  Created by Angelique Babin on 24/09/2020.
//

import UIKit
import RealmSwift
import UserNotifications
import GoogleMobileAds
import SwiftUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        let config = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { (migration: Migration, oldSchemaVersion: UInt64) in
                
            })
        Realm.Configuration.defaultConfiguration = config
//        registerForLocalNotifications()
        configureNotification()
        
//        NotificationHelper.setNotificationCategories()
        
        // Ok - test in SunVC
        //        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
        //            if granted {
        //                print("We'll be able to set Reminders!")
        //            } else if error != nil {
        //                print("error occurred")
        //            }
        //        }
        //        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        
        //        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { success, error in
        //            if success {
        //                self.createReminder()
        //                print("reminds array in activationAlarm : \(self.reminds)")
        //            } else if error != nil {
        //                print("error occurred")
        //            }
        //        })
        
        //        deleteRealmIfMigrationNeeded: true
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
//        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["04b5955b04ab689e9a3e11e6927572c3"] // Sample device ID
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    
//    private func registerForLocalNotifications(options: UNAuthorizationOptions = [.alert, .sound, .badge]) {
//         let center = UNUserNotificationCenter.current()
//         center.requestAuthorization(options: options) { (granted, error) in
//             if !granted {
//                 print("Unable to register")
//             }
//         }
//     }
    
    private func configureNotification() {
        let notifCenter = UNUserNotificationCenter.current()
        notifCenter.delegate = self
//        notifCenter.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
//            print("Notification auth response : \(granted). Error : \(String(describing: error))")
//        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print(notification.request.content.title)
        completionHandler([.alert, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response.notification.request.content.userInfo)
        print(response.actionIdentifier)
        
        if let titleNotif = response.notification.request.content.userInfo["title"] as? String {
            print(titleNotif)
        }
        
//        switch response.actionIdentifier {
//        case UNNotificationDismissActionIdentifier:
//            print("Dismiss Action")
//        case UNNotificationDefaultActionIdentifier:
//            print("Default Action")
//  //            UserSettings.stateNotification = false
//  //            print("UserSettings State notification : \(UserSettings.stateNotification.description)")
//        case NotificationAction.snooze.rawValue:
//            print("Snooze")
//        case NotificationAction.delete.rawValue:
//            print("Delete")
//            let identifier = response.notification.request.identifier
//            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
//        default:
//            return
//        }
        completionHandler()
    }
}
