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
    
    func getSunsetSunriseNoFormatted(date: String, completionHandler: @escaping (Bool, SunNoFormattedAPI?) -> Void) {
        guard let url = createSunNoFormattedApiUrl(date: date) else { return }
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
            guard let sunApi = try? JSONDecoder().decode(SunNoFormattedAPI.self, from: jsonData) else {
                completionHandler(false, nil)
                return
            }
            completionHandler(true, sunApi)
        }
    }
    
    private func createSunNoFormattedApiUrl(date: String) -> URL? {
        guard let url = URL(string: sunSession.urlStringApi + date) else { return nil }
        return url
    }
}
