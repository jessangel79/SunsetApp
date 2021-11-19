//
//  IntExtensionTests.swift
//  SunsetAppTests
//
//  Created by Angelique Babin on 13/11/2021.
//

import XCTest
@testable import SunsetApp

class IntExtensionTests: XCTestCase {
    
    // MARK: - Test Extension Int

    func testConvertSecondsInHours() throws {
        XCTAssertEqual("9:22:12", 33732.convertSecondsInHours())
    }
}
