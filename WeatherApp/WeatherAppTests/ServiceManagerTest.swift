//
//  ServiceManagerTest.swift
//  WeatherApp
//
//  Created by Karthik Kumaravel on 5/10/17.
//  Copyright © 2017 Karthik Kumaravel. All rights reserved.
//

import XCTest
@testable import WeatherApp

class ServiceManagerTest: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSingleton() {
        let manager = ServiceManager.sharedInstance
        let manager2 = ServiceManager.sharedInstance
        
        XCTAssertEqual(manager, manager2)
    }
    
    func testServiceCall() {
        ServiceManager.sharedInstance.getCurrentWeather(city:"newark", completion: {  (result : WeatherResponse) in
            XCTAssertNotNil(result)
            XCTAssertNotNil(result.weatherList)
        }) { (error : NSError) in
            XCTAssertFalse(true, "should not throw error at this stage")
        }
    }
    
    func testServiceCallFailure() {
        ServiceManager.sharedInstance.getCurrentWeather(city:"nwe2", completion: {  (result : WeatherResponse) in
            XCTAssertFalse(true, "should not throw success at this stage")
        }) { (error : NSError) in
            XCTAssertNotNil(error)
            
        }
    }
}
