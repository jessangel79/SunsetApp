//
//  SunService.swift
//  SunsetApp
//
//  Created by Angelique Babin on 24/09/2020.
//

import Foundation

final class SunService {
    
    // MARK: - Vars
    
    private let sunSession: SunProtocol
    
    init(sunSession: SunProtocol = SunSession()) {
        self.sunSession = sunSession
    }
    
    // MARK: - Methods
    
    func getSunsetSunrise(date: String, lat: String, long: String, completionHandler: @escaping (Bool, SunAPI?) -> Void) {
        guard let url = createSunApiUrl(date: date, lat: lat, long: long) else { return }
        print("getSunsetSunriseNoFormatted :\(url)")
        
        sunSession.request(url: url) { responseData in
            guard responseData.response?.statusCode == 200 else {
                completionHandler(false, nil)
                return
            }
            guard let jsonData = responseData.data else {
                completionHandler(false, nil)
                return
            }
            guard let sunApi = try? JSONDecoder().decode(SunAPI.self, from: jsonData) else {
                completionHandler(false, nil)
                return
            }
            completionHandler(true, sunApi)
        }
    }
    
    private func createSunApiUrl(date: String, lat: String, long: String) -> URL? {
        let myLat = sunSession.stringLatitude + lat
        let myLong = sunSession.stringLongitude + long
        let myDate = sunSession.stringDate + date
        guard let url = URL(string: sunSession.urlStringApi + myDate + myLat + myLong) else { return nil }
        return url
    }
}
