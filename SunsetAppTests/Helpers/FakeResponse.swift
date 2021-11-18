//
//  Fake.swift
//  SunsetAppTests
//
//  Created by Angelique Babin on 24/09/2020.
//

import Foundation
import Alamofire

struct FakeResponse {
    var response: HTTPURLResponse?
    var data: Data?
    var result: Result<Any, AFError>?
}
