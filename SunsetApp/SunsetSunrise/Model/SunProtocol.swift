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

    var lat: String {
        return "lat=49.051111"
    }

    var lng: String {
        return "lng=2.206869"
    }

//    var date: String {
//        return "date=today"
//    }

    /// url  for API to get places
    var urlStringApi: String {
        return "\(scheme)://\(host)/\(format)?\(lat)&\(lng)&date="
//        return "\(scheme)://\(host)/\(format)?\(lat)&\(lng)&\(date)"
    }
    
    // https://api.sunrise-sunset.org/json?lat=49.051111&lng=2.206869&date=2020-09-26 // today
    
}
