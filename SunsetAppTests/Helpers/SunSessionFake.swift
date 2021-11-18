//
//  SunSessionFake.swift
//  SunsetAppTests
//
//  Created by Angelique Babin on 12/11/2021.
//

import Foundation
import Alamofire
@testable import SunsetApp

class SunSessionFake: SunProtocol {

    private let fakeResponse: FakeResponse
    
    init(fakeResponse: FakeResponse) {
        self.fakeResponse = fakeResponse
    }

    func request(url: URL, completionHandler: @escaping (AFDataResponse<Any>) -> Void) {
        let httpResponse = fakeResponse.response
        let data = fakeResponse.data
        guard let result = fakeResponse.result else { return }
        
        guard let url = createSunApiUrl(date: String(), lat: String(), long: String()) else { return }
        let urlRequest = URLRequest(url: url)
        
        let response = AFDataResponse<Any>(request: urlRequest, response: httpResponse, data: data, metrics: nil, serializationDuration: 1.0, result: result)
        completionHandler(response)
    }
        
    func createSunApiUrl(date: String, lat: String, long: String) -> URL? {
        let myLat = stringLatitude + lat
        let myLong = stringLongitude + long
        let myDate = stringDate + date
        guard let url = URL(string: urlStringApi + myDate + myLat + myLong) else { return nil }
        return url
    }
}
