//
//  FakeResponseData.swift
//  SunsetAppTests
//
//  Created by Angelique Babin on 12/11/2021.
//

import Foundation
import Alamofire
import UIKit

class FakeResponseData {
    
    // MARK: - Response
    
    static let responseOK = HTTPURLResponse(url: URL(string: "https://www.google.fr")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    static let responseKO = HTTPURLResponse(url: URL(string: "https://www.google.fr")!, statusCode: 500, httpVersion: nil, headerFields: nil)!
    
    // MARK: - Result
    
    static var result: Result<Any, AFError> {
        return .success("success")
    }

    // MARK: - Data
    
    static var correctDataSunset: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        guard let url = bundle.url(forResource: "SunAPI", withExtension: "json") else {
            fatalError("SunAPI.json is not found.")
        }
        guard let data = try? Data(contentsOf: url) else { return Data() }
        return data
    }
    
    static let incorrectData = "erreur".data(using: .utf8)!
}
