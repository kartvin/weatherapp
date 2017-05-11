//
//  WeatherAppUITests.swift
//  WeatherAppUITests
//
//  Created by Karthik Kumaravel on 5/10/17.
//  Copyright © 2017 Karthik Kumaravel. All rights reserved.
//

import XCTest

class WeatherAppUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDiplayItems() {
        
        let app = XCUIApplication()
        XCTAssertTrue(app.staticTexts["Temperature:"].exists)
        XCTAssertTrue(app.staticTexts["Pressure:"].exists)
        XCTAssertTrue(app.staticTexts["Humidity:"].exists)
        XCTAssertTrue(app.staticTexts["Minimun Temperature:"].exists)
        XCTAssertTrue(app.staticTexts["Maximum Temperature:"].exists)
    }
    
}
