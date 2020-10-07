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
        case errorAccess
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
        case .errorAccess:
            title = "Error Acces"
            message = "Sorry there is an error to access the calendar."
        case .noNotification:
            title = "No notification"
            message = "Sorry there is no scheduled notification yet !"
        case .notificationActive:
            title = "Notification scheduled"
            message = "A notification has been scheduled"
        case .notificationDeleted:
            title = "Notifications deleted"
            message = "The notifications have been deleted"
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
    
    func presentAlertAction (_ title: String, _ message: String) {
        let action = UIAlertAction(title: "OK", style: .default)
        alertCustomAction(title, message, action: action)
    }
    
    /// Alert message for user to confirm all reset
    func showResetAlert(destructiveAction: UIAlertAction) {
        let alert = UIAlertController(title: "Warning Reset All", message: "Are you sure to reset all ?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(destructiveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showAlertAction(action: UIAlertAction) {
        let alert = UIAlertController(title: "Sunset", message: "Are you sure to activate the notification for sunset time ?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}
