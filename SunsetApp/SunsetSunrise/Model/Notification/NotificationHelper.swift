//
//  NotificationHelper.swift
//  SunsetApp
//
//  Created by Angelique Babin on 01/10/2020.
//

import Foundation
//import NotificationCenter
import UserNotifications

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
            repeats: false
        )

        let request = UNNotificationRequest(identifier: "\(notification.id)", content: content, trigger: trigger) // "some_long_id"
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        print("notification created : \(notification.id)")
    }
    
    static func removeLocalNotification(_ notification: NotificationModel) {
        // delete notification with id
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(notification.id)"])
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["\(notification.id)"])
//        print("notification deleted with id in addLocalNotification : \(notification.id)")
    }
    
    static func removeAllLocalNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
//        print("All notifications deleted in addLocalNotification")

    }
}
