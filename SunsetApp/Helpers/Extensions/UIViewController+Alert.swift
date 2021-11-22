//
//  UIViewController+Alert.swift
//  SunsetApp
//
//  Created by Angelique Babin on 24/09/2020.
//

import UIKit

// MARK: - Extension to display an alert message to the user

extension UIViewController {
    
    /// Enumeration of the error
    enum AlertError {
        case error
        case noNotification
        case notificationActive
        case notificationDeleted
        case authorizationStatusLocationDenied
        case updateData
    }
    
    /// Alert message for user
    func presentAlert(typeError: AlertError) {
        var message: String
        var title: String
      
        switch typeError {
        case .error:
            title = "Error"
            message = "Sorry an error is occured."
        case .noNotification:
            title = "No notification"
            message = "Sorry there is no scheduled notification yet !"
        case .notificationActive:
            title = "Notification scheduled"
            message = "The notification has been scheduled"
        case .notificationDeleted:
            title = "Notification canceled"
            message = "The notification have been canceled"
        case .authorizationStatusLocationDenied:
            title = "You have denied access to your location !"
            message = "Sorry but you have denied access to your location, this app cannot work properly"
        case .updateData:
            title = "Updated datas"
            message = "The datas has been updated "
        }
        alertError(title, message)
    }
    
    /// Base of alert for custom action
    private func alertCustomAction(_ title: String, _ message: String, action: UIAlertAction) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    private func alertError(_ title: String, _ message: String) {
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertCustomAction(title, message, action: action)
    }
    
    func showAlertAction(action: UIAlertAction) {
        let alert = UIAlertController(title: "Incorrect date", message: "The date has passed for today, do you want to schedule a notification for tomorrow ? ", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}
