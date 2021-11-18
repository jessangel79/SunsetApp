//
//  SunProtocol.swift
//  SunsetApp
//
//  Created by Angelique Babin on 24/09/2020.
//

import Foundation
import Alamofire

protocol SunProtocol {
    var urlStringApi: String { get }
    func request(url: URL, completionHandler: @escaping (AFDataResponse<Any>) -> Void) // @escaping (AFDataResponse<Any>) // @escaping (DataResponse<Any, AFError>)
}

extension SunProtocol {
    
    var scheme: String {
        return "https"
    }

    var host: String {
        return "api.sunrise-sunset.org"
    }

    var format: String {
        return "json"
    }
    
    var noFormatted: String {
        return "formatted=0"
    }
    
    var stringDate: String {
        return "&date="
    }
    
    var stringLatitude: String {
        return "&lat="
    }
    
    var stringLongitude: String {
        return "&lng="
    }

    /// url  for API to get sunset, surise and lengthday with date not formatted
    var urlStringApi: String {
        return "\(scheme)://\(host)/\(format)?\(noFormatted)"
//        return "\(scheme)://\(host)/\(format)?\(lat)&\(lng)&\(noFormatted)&date="
//        return "\(scheme)://\(host)/\(format)?\(noFormatted)&date="
    }
    
//    https://api.sunrise-sunset.org/json?lat=49.051111&lng=2.206869&date=2020-09-26 // today
//    https://api.sunrise-sunset.org/json?formatted=0&date=2020-09-26&lat=49.051111&lng=2.206869 // Date not formatted date in first
//    https://api.sunrise-sunset.org/json?lat=49.051111&lng=2.206869&formatted=0&date=2020-09-26 // Date not formatted
    
}
