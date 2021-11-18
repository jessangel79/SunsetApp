//
//  UIViewController+CustomUI.swift
//  SunsetApp
//
//  Created by Angelique Babin on 24/09/2020.
//

import UIKit

// MARK: - Extension to custom buttons, views and labels

extension UIViewController {

    /// custom view
    func customView(view: UIView, radius: CGFloat, width: CGFloat, colorBorder: UIColor) {
        view.layer.cornerRadius = radius
        view.layer.borderWidth = width
        view.layer.borderColor = colorBorder.cgColor
    }
    
    /// custom view with shadow
    func customShadowView(view: UIView) {
        view.clipsToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.8
        view.layer.shadowOffset = CGSize(width: 1, height: 1)
    }
}
