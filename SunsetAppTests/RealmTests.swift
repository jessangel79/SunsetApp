//
//  RealmTests.swift
//  SunsetAppTests
//
//  Created by Angelique Babin on 17/11/2021.
//

import XCTest
@testable import SunsetApp
import RealmSwift

class RealmTests: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = "RealmTests"
    }

    // MARK: - Helpers
    
    let config = Realm.Configuration(inMemoryIdentifier: "RealmTests")
    
    func getSunResult() -> ResultsApi? {
        let date = "2021-11-12"
        let lat = "48.87035207937362"
        let long = "2.3494364411919713"
        var result: ResultsApi?
        let fakeResponse = FakeResponse(response: FakeResponseData.responseOK, data: FakeResponseData.correctDataSunset, result: FakeResponseData.result)
        let sunSessionFake = SunSessionFake(fakeResponse: fakeResponse)
        let sunService = SunService(sunSession: sunSessionFake)
        sunService.getSunsetSunrise(date: date, lat: lat, long: long) { success, sunAPI in
            result = sunAPI?.results
        }
        return result
    }

    // Test Code
    
    func testSaveDataSunWhenGetSunriseSuccess() throws {
        let currentDate = Date().toString(format: FormatDate.noFormatted.rawValue)
        let tomorrowDate = Date().addingTimeInterval(86400).toString(format: FormatDate.noFormatted.rawValue)
        var oldDateNoFormatted = "2021-11-11T06:53:40+00:00"
//        let config = Realm.Configuration(inMemoryIdentifier: "RealmTests")
        guard let testRealm = try? Realm(configuration: config) else { return }
        guard let sunApiResults = getSunResult() else { return }
        let dataSun = StructDataManager(sunApiResults: sunApiResults, currentDate: currentDate, tomorrowDate: tomorrowDate, realm: testRealm)
        let dataManager = DataManager()
        dataManager.saveDataSun(data: dataSun, oldDateNoFormatted: &oldDateNoFormatted)
        
        XCTAssertEqual(testRealm.objects(Sun.self).first?.sunset, "2021-11-12T16:15:52+00:00".transformHour())
        XCTAssertEqual(testRealm.objects(Sun.self).first?.dayLength, 33732.convertSecondsInHours())
        XCTAssertEqual(testRealm.objects(Sun.self).first?.sunsetNoFormatted, "2021-11-12T16:15:52+00:00")
    }
    
    func testDeleteAllDataSun() {
//        let config = Realm.Configuration(inMemoryIdentifier: "RealmTests")
        guard let testRealm = try? Realm(configuration: config) else { return }
        let dataManager = DataManager()
        dataManager.deleteAllDataSun(realm: testRealm)
        XCTAssertEqual(true, testRealm.objects(Sun.self).isEmpty)
    }

}
