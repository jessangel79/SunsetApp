//
//  DateExtensionTests.swift
//  SunsetAppTests
//
//  Created by Angelique Babin on 08/11/2021.
//

import XCTest
@testable import SunsetApp

class DateExtensionTests: XCTestCase {
    
    func testDateIsCorrect() throws {
        XCTAssertEqual(false, Date().checkDate())
        XCTAssertEqual(true, Date().addingTimeInterval(10).checkDate())
    }
}
