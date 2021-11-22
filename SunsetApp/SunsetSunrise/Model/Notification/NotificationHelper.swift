//
//  NotificationHelper.swift
//  SunsetApp
//
//  Created by Angelique Babin on 01/10/2020.
//

import Foundation
import UserNotifications

enum NotificationCategory: String {
    case sunsetCat
}

enum NotificationAttachment: String {
    case logo = "logoSunset"
}

class NotificationHelper: NSObject {
    
    static var stateNotification: Bool?
    
    static func requestAuthorization(_ notification: NotificationModel, _ date: Date) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("We'll be able to set Reminders!")
                if date.checkDate() {
                    addLocalNotification(notification)
                }
            } else if error != nil {
                print("error occurred")
            }
        }
    }
    
    static func addLocalNotification(_ notification: NotificationModel) {
        
        let content = UNMutableNotificationContent()
        content.title = notification.title
        content.sound = .default
        content.body = notification.message
        content.badge = 1
        content.categoryIdentifier = NotificationCategory.sunsetCat.rawValue
        if let imageUrl = Bundle.main.url(forResource: NotificationAttachment.logo.rawValue,
                                          withExtension: "png"),
           let attachment = try? UNNotificationAttachment(identifier: NotificationAttachment.logo.rawValue,
                                                          url: imageUrl,
                                                          options: nil) {
            content.attachments = [attachment]
        }
        content.userInfo = ["title": notification.title]
        
        let targetDate = notification.plannedFor
//        print("target Date createReminder : \(targetDate)")
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate),
            repeats: false
        )
        
        let request = UNNotificationRequest(identifier: "\(notification.id)", content: content, trigger: trigger) // "some_long_id"
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
//        print("notification created : \(notification.id)")
    }

    static func removeAllLocalNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        //        print("All Pending Notifications deleted")
    }
    
    static func removeAllLocalNotificationDelivered() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        //        print("All Delivered Notifications deleted")
    }
}
