//
//  LocationManagerDelegate.swift
//  SunsetApp
//
//  Created by Angelique Babin on 11/11/2021.
//

import Foundation
import CoreLocation
import SwiftUI

//class LocationManagerDelegate: NSObject, CLLocationManagerDelegate {
//    
//    let locationManager = CLLocationManager()
//    var userPosition: CLLocation?
//    var latitude: Double?
//    var longitude: Double?
//    var coordinateInit: CLLocationCoordinate2D {
//        return CLLocationCoordinate2D(
//            latitude: latitude ?? Cst.CoordinatesInit.latitudeInit.transformToDouble(),
//            longitude: longitude ?? Cst.CoordinatesInit.longitudeInit.transformToDouble())
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if locations.count > 0 {
//            if let myPosition = locations.last {
//                userPosition = myPosition
//            }
//        }
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        if let error = error as? CLError, error.code == .denied {
//            manager.stopUpdatingLocation()
//            return
//        }
//  //        presentAlert(typeError: .error)
//    }
//    
//    func setupLocationManager() {
//  //        locationManager.delegate = self
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.requestLocation()
//        authorizationStatusAccessLocation()
//    }
//    
//    private func authorizationStatusAccessLocation() {
//        switch CLLocationManager.authorizationStatus() {
//        case .denied, .restricted:
//            return
//  //            presentAlert(typeError: .authorizationStatusLocationDenied)
//        case .authorizedAlways, .authorizedWhenInUse:
//            locateUser()
//        case .notDetermined:
//            locationManager.requestWhenInUseAuthorization()
//        @unknown default:
//            locationManager.requestWhenInUseAuthorization()
//        }
//    }
//        
//    func locateUser() {
//        guard let userPositionCoordinate = userPosition?.coordinate else { return }
//        latitude = userPositionCoordinate.latitude
//        longitude = userPositionCoordinate.longitude
//    }
//}
