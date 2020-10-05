//
//  NotificationHelper.swift
//  SunsetApp
//
//  Created by Angelique Babin on 01/10/2020.
//

import Foundation
import NotificationCenter

class NotificationHelper {
    static func addLocalNotification(_ notification: NotificationModel) {
        
        let content = UNMutableNotificationContent()
        content.title = notification.title
        content.sound = .default
        content.body = notification.message

        let targetDate = notification.plannedFor // date
        print("target Date createReminder : \(targetDate)")

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate),
            repeats: true
        )

        let request = UNNotificationRequest(identifier: "\(notification.id)", content: content, trigger: trigger) // "some_long_id"
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        print("notification created : \(notification.id)")
    }
    
    static func removeLocalNotification(_ notification: NotificationModel) {
        // delete notification with id
//        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(notification.id)"])
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["\(notification.id)"])
    }
    
//    static func removeAllLocalNotification(_ notification: NotificationModel) {
//        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
//    }
}
