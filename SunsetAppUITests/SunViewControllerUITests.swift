//
//  SunViewControllerUITests.swift
//  SunsetAppUITests
//
//  Created by Angelique Babin on 24/09/2020.
//

import XCTest

class SunViewControllerUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        app = XCUIApplication()
        app.launchEnvironment["view"] = "SunViewController"
        app.launch()
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        XCUIDevice.shared.orientation = .portrait
    }

    override func tearDownWithError() throws {}

    func testTapTomorrow() throws {
        app.buttons["Tomorrow"].tap()
        XCTAssertTrue(app.segmentedControls.firstMatch.exists)
    }
    
    func testTapActiveNotification() throws {
        app.buttons["Tomorrow"].tap()
        app.buttons["active"].tap()
        XCTAssertTrue(app.alerts.element.exists)
        XCTAssertTrue(app.alerts.staticTexts["Notification scheduled"].exists)
    }
    
//    func testTapActiveNotificationButDateNotCorrect() throws {
//        app.buttons["Today"].tap()
//        app.buttons["active"].tap()
//        XCTAssertTrue(app.alerts.element.exists)
//        XCTAssertTrue(app.alerts.staticTexts["Incorrect date"].exists)
//    }
    
    func testTapClickOnAlertOk() throws {
        app.buttons["Tomorrow"].tap()
        app.buttons["active"].tap()
        XCTAssertTrue(app.alerts.element.exists)
        XCTAssertTrue(app.alerts.staticTexts["Notification scheduled"].exists)
        app.alerts["Notification scheduled"].scrollViews.otherElements.buttons["OK"].tap()
        XCTAssertFalse(app.alerts.element.exists)
    }
    
    func testTapDesactiveNotification() throws {
        app.buttons["Tomorrow"].tap()
        app.buttons["active"].tap()
        app.alerts["Notification scheduled"].scrollViews.otherElements.buttons["OK"].tap()
        let cancelButton = app.buttons["cancel"]
        cancelButton.tap()
        XCTAssertTrue(app.alerts.element.exists)
        XCTAssertTrue(app.alerts.staticTexts["Notification canceled"].exists)
        app.alerts["Notification canceled"].scrollViews.otherElements.buttons["OK"].tap()
        cancelButton.tap()
        XCTAssertTrue(app.alerts.element.exists)
        XCTAssertTrue(app.alerts.staticTexts["No notification"].exists)
        app.alerts["No notification"].scrollViews.otherElements.buttons["OK"].tap()
        XCTAssertFalse(app.alerts.element.exists)
    }
    
    func testButtonInformationToButtonFreepik() throws {
        app.navigationBars["Sun"].buttons["Info"].tap()
        app.staticTexts["Icons made by Freepik"].tap()
        XCTAssertTrue(app.webViews.element.exists)
    }
    
    func testButtonInformationToButtonFlaticon() throws {
        app.navigationBars["Sun"].buttons["Info"].tap()
        app.staticTexts[" from Flaticon"].tap()
        XCTAssertTrue(app.webViews.element.exists)
    }
    
    func testButtonInformationToButtonAPI() throws {
        app.navigationBars["Sun"].buttons["Info"].tap()
        app.staticTexts["API : https://sunrise-sunset.org/api"].tap()
        XCTAssertTrue(app.webViews.element.exists)
    }
    
    func testButtonRefresh() {
        app.navigationBars["Sun"].buttons["Refresh"].tap()
        XCTAssertTrue(app.alerts.element.exists)
        XCTAssertTrue(app.alerts.staticTexts["Updated datas"].exists)
        app.alerts["Updated datas"].scrollViews.otherElements.buttons["OK"].tap()
        XCTAssertFalse(app.alerts.element.exists)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
