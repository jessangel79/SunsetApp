//
//  StringExtensionTests.swift
//  SunsetAppTests
//
//  Created by Angelique Babin on 13/11/2021.
//

import XCTest
@testable import SunsetApp
import RealmSwift

class StringExtensionTests: XCTestCase {
    
    // MARK: - Properties
    
    let realmTests = RealmTests()
    
    // MARK: - Test Extension String

    func testTransformDateInHour() throws {
        XCTAssertEqual("17:15:52", "2021-11-12T16:15:52+00:00".transformHour())
    }
    
    func testTransformDateNoFormattedInDateFormatted() throws {
        XCTAssertEqual("2021-11-12", "2021-11-12T16:15:52+00:00".transformDate())
    }
    
    func testGetOldDateFormatted() throws {
        guard let testRealm = try? Realm(configuration: realmTests.config) else { return }
        realmTests.saveDataSun(testRealm)
        let sunList = testRealm.objects(Sun.self)
        XCTAssertEqual("2021-11-11T06:53:40+00:00".getOldDate(sunList: sunList, format: FormatDate.formatted.rawValue), "2021-11-11")

    }
}
