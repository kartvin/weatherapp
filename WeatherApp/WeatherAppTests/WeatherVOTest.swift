//
//  WeatherVOTest.swift
//  WeatherApp
//
//  Created by Karthik Kumaravel on 5/10/17.
//  Copyright © 2017 Karthik Kumaravel. All rights reserved.
//

import XCTest
@testable import WeatherApp

class WeatherVOTest: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testEmptyInitialization() {
        let result = WeatherVO()
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result.id, 0)
        XCTAssertEqual(result.main, "")
        XCTAssertEqual(result.weatherDescription, "")
        XCTAssertEqual(result.icon, "")
        XCTAssertEqual(result.iconUrl, "")
    }
}
