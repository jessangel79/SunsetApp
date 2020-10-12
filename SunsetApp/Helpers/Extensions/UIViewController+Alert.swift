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
}
