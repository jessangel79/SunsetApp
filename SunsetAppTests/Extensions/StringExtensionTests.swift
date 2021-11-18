//
//  StringExtensionTests.swift
//  SunsetAppTests
//
//  Created by Angelique Babin on 13/11/2021.
//

import XCTest
@testable import SunsetApp

class StringExtensionTests: XCTestCase {
    
    func testTransformDateInHour() throws {
        XCTAssertEqual("17:15:52", "2021-11-12T16:15:52+00:00".transformHour())
    }
    
    func testTransformDateNoFormattedInDateFormatted() throws {
        XCTAssertEqual("2021-11-12", "2021-11-12T16:15:52+00:00".transformDate())
    }
}
