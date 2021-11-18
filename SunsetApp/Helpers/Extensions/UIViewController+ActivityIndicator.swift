//
//  UIViewController+ActivityIndicator.swift
//  SunsetApp
//
//  Created by Angelique Babin on 24/09/2020.
//

import UIKit

// MARK: - Extension to manage the ActivityIndicator

extension UIViewController {
    
    /// manage the ActivityIndicator with UIView
    func toggleActivityIndicator(shown: Bool, activityIndicator: UIActivityIndicatorView, view: UIView) {
        activityIndicator.isHidden = !shown
        view.isHidden = shown
    }
}
