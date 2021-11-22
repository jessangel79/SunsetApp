//
//  SunsetAppTests.swift
//  SunsetAppTests
//
//  Created by Angelique Babin on 24/09/2020.
//

import XCTest
@testable import SunsetApp
import Alamofire
import UserNotifications

class SunsetAppTests: XCTestCase {
    
    // MARK: - Properties
    
    var date: String!
    var lat: String!
    var long: String!
    var title: String!
    var body: String!
    
    // MARK: - Tests Life Cycle
    
    override class func setUp() {
        super.setUp()
        
    }

    override func setUpWithError() throws {
        date = "2021-11-12"
        lat = "48.87035207937362"
        long = "2.3494364411919713"
        title = "Bye Bye Sun !"
        body = "The sun has set. The shutters must be closed !!!"
    }

    override func tearDownWithError() throws {}
    
    // MARK: - Helpers
    
    /// En test
    func executeRunLoop() {
        RunLoop.current.run(until: Date())
    }
    
    // MARK: - Tests SunService
    
    func testCreateSunApiUrl() throws {
        let fakeResponse = FakeResponse(response: FakeResponseData.responseOK, data: FakeResponseData.correctDataSunset, result: nil)
        let sunSessionFake = SunSessionFake(fakeResponse: fakeResponse)
        let createSunApiUrl = sunSessionFake.createSunApiUrl(date: date, lat: lat, long: long)
        XCTAssertEqual(createSunApiUrl, URL(string: "https://api.sunrise-sunset.org/json?formatted=0&date=2021-11-12&lat=48.87035207937362&lng=2.3494364411919713"))
    }
    
    func testGetSunsetSunriseShouldPostSuccessCallbackIfNoErrorAndCorrectData() throws {
        let fakeResponse = FakeResponse(response: FakeResponseData.responseOK, data: FakeResponseData.correctDataSunset, result: FakeResponseData.result)
        let sunSessionFake = SunSessionFake(fakeResponse: fakeResponse)
        let sunService = SunService(sunSession: sunSessionFake)
//        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sunService.getSunsetSunrise(date: date, lat: lat, long: long) { success, sunAPI in
            XCTAssertTrue(success)
            XCTAssertNotNil(sunAPI)
        }
        executeRunLoop() /// Test
    }
    
    func testGetSunsetSunriseShouldPostFailedCallbackIfIncorrectData() throws {
        let fakeResponse = FakeResponse(response: FakeResponseData.responseOK, data: FakeResponseData.incorrectData, result: FakeResponseData.result)
        let sunSessionFake = SunSessionFake(fakeResponse: fakeResponse)
        let sunService = SunService(sunSession: sunSessionFake)
        sunService.getSunsetSunrise(date: date, lat: lat, long: long) { success, sunAPI in
            XCTAssertFalse(success)
            XCTAssertNil(sunAPI)
        }
    }
    
    func testGetSunsetSunriseShouldPostFailedCallbackIfResponseCorrectAndDataNil() throws {
        let fakeResponse = FakeResponse(response: FakeResponseData.responseOK, data: nil, result: FakeResponseData.result)
        let sunSessionFake = SunSessionFake(fakeResponse: fakeResponse)
        let sunService = SunService(sunSession: sunSessionFake)
        sunService.getSunsetSunrise(date: date, lat: lat, long: long) { success, sunAPI in
            XCTAssertFalse(success)
            XCTAssertNil(sunAPI)
        }
    }
    
    func testGetSunsetSunriseShouldPostFailedCallBack() throws {
        let fakeResponse = FakeResponse(response: nil, data: nil, result: FakeResponseData.result)
        let sunSessionFake = SunSessionFake(fakeResponse: fakeResponse)
        let sunService = SunService(sunSession: sunSessionFake)
        sunService.getSunsetSunrise(date: date, lat: lat, long: long) { success, sunAPI in
            XCTAssertFalse(success)
            XCTAssertNil(sunAPI)
        }
    }
    
    // MARK: - Tests NotificationHelper
    
    func testNotificationHelperIfRequesAuthorizationIsGrantedAndSuccessOfAddNotification() throws {
        let fakeDateNotification = Date()
        let notificationModel = NotificationModel(title: title, message: body, plannedFor: fakeDateNotification)
        NotificationHelper.requestAuthorization(notificationModel, fakeDateNotification)
        NotificationHelper.addLocalNotification(notificationModel)
        let ifNotificationAdded = UNUserNotificationCenter.getPendingNotificationRequests
        XCTAssertEqual(false, [ifNotificationAdded].isEmpty)
        // UNUserNotificationCenter getPendingNotificationRequestsWithCompletionHandler
        XCTAssertEqual("\(notificationModel.plannedFor)", "\(Date())")
        XCTAssertEqual(notificationModel.message, "The sun has set. The shutters must be closed !!!")
        XCTAssertEqual(notificationModel.title, "Bye Bye Sun !")
    }
}
