//
//  UIViewController+CustomUI.swift
//  SunsetApp
//
//  Created by Angelique Babin on 24/09/2020.
//

import UIKit

// MARK: - Extension to custom buttons, views and labels

extension UIViewController {
    
    /// custom buttons collection
//    func customAllButtons(allButtons: [UIButton], radius: CGFloat, width: CGFloat, colorBackground: UIColor, colorBorder: UIColor) {
//        for button in allButtons {
//            customButton(button: button, radius: radius, width: width, colorBackground: colorBackground, colorBorder: colorBorder)
//        }
//    }
    
    /// custom button
    func customButton(button: UIButton, radius: CGFloat, width: CGFloat, colorBackground: UIColor, colorBorder: UIColor) {
        button.layer.cornerRadius = radius
        button.layer.borderWidth = width
        button.layer.backgroundColor = colorBackground.cgColor
        button.layer.borderColor = colorBorder.cgColor
    }
    
    /// custom collection buttons
    func customButtons(buttons: [UIButton], radius: CGFloat, width: CGFloat, colorBackground: UIColor, colorBorder: UIColor) {
        for button in buttons {
            customButton(button: button, radius: radius, width: width, colorBackground: colorBackground, colorBorder: colorBorder)
        }
    }
    
    /// custom button with shadow
    func customShadowButton(button: UIButton) {
        button.clipsToBounds = false
        button.layer.cornerRadius = 20
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.8
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
    }
    
    /// custom collection buttons with shadow
    func customShadowButtons(buttons: [UIButton]) {
        for button in buttons {
            customShadowButton(button: button)
        }
    }
    
    /// custom labels collection
//    func customAllLabels(allLabels: [UILabel], radius: CGFloat, width: CGFloat, colorBackground: UIColor, colorBorder: UIColor) {
//        for label in allLabels {
//            customLabel(label: label, radius: radius, width: width, colorBackground: colorBackground, colorBorder: colorBorder)
//        }
//    }
    
    /// custom label
//    func customLabel(label: UILabel, radius: CGFloat, width: CGFloat, colorBackground: UIColor, colorBorder: UIColor) {
//        label.layer.cornerRadius = radius
//        label.layer.borderWidth = width
//        label.layer.backgroundColor = colorBackground.cgColor
//        label.layer.borderColor = colorBorder.cgColor
//    }
    
    /// custom view
    func customView(view: UIView, radius: CGFloat, width: CGFloat, colorBorder: UIColor) { // colorBackground: UIColor, 
        view.layer.cornerRadius = radius
        view.layer.borderWidth = width
//        view.layer.backgroundColor = colorBackground.cgColor
        view.layer.borderColor = colorBorder.cgColor
    }
    
    /// custom view with shadow
    func customShadowView(view: UIView) {
        view.clipsToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.8
        view.layer.shadowOffset = CGSize(width: 1, height: 1)
    }
    
    /// custom image view
    func customImageView(imageView: UIImageView, radius: CGFloat, width: CGFloat, colorBorder: UIColor) {
        imageView.layer.cornerRadius = radius
        imageView.layer.borderWidth = width
        imageView.layer.borderColor = colorBorder.cgColor
    }
    
    /// custom view with shadow
    func customShadowImageView(imageView: UIImageView) {
        imageView.clipsToBounds = false
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 0.8
        imageView.layer.shadowOffset = CGSize(width: 1, height: 1)
    }
}
