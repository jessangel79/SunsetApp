//
//  SunSession.swift
//  SunsetApp
//
//  Created by Angelique Babin on 24/09/2020.
//

import Foundation
import Alamofire

class SunSession: SunProtocol {
    func request(url: URL, completionHandler: @escaping (AFDataResponse<Any>) -> Void) { // @escaping (AFDataResponse<Any>) // @escaping (DataResponse<Any, AFError>)
        AF.request(url).responseJSON { responseData in
            completionHandler(responseData)
        }
    }
}
