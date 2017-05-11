//
//  WeatherResponseTest.swift
//  WeatherApp
//
//  Created by Karthik Kumaravel on 5/10/17.
//  Copyright © 2017 Karthik Kumaravel. All rights reserved.
//

import XCTest
@testable import WeatherApp


class WeatherResponseTest: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testEmptyInitialization() {
        let result = WeatherResponse()
        XCTAssertNotNil(result)
        XCTAssertEqual(result.code, 0)
        XCTAssertEqual(result.temp, 0)
        XCTAssertEqual(result.pressure, 0)
        XCTAssertEqual(result.humidity, 0)
        XCTAssertEqual(result.temp_min, 0)
        XCTAssertEqual(result.temp_max, 0)
        XCTAssertEqual(result.message, "")
        XCTAssertEqual(result.name, "")
        XCTAssertNotNil(result.weatherList)
        XCTAssertEqual(result.weatherList.count, 0)
    }
}
