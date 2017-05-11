//
//  RestClientTest.swift
//  WeatherApp
//
//  Created by Karthik Kumaravel on 5/10/17.
//  Copyright © 2017 Karthik Kumaravel. All rights reserved.
//

import XCTest
@testable import WeatherApp

class RestClientTest: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testServiceResponse() {
        let httpClient = RestClient()
        var request = URLRequest(url: URL(string: "http://api.openweathermap.org/data/2.5/weather?q=new%20york&APPID=64b93e1ce1a20ecad43bae020858fe1f")!)
        request.httpMethod = "GET"
        httpClient.makeGetRequest(request: request, completion: { (data: NSData) in
            XCTAssertNotNil(data)
        }) { (error : NSError) in
            XCTAssertFalse(true, "should not throw error")
        }
    }
    
    func testFailureServiceResponse() {
        let httpClient = RestClient()
        var request = URLRequest(url: URL(string: "http://random")!)
        request.httpMethod = "GET"
        httpClient.makeGetRequest(request: request, completion: { (data: NSData) in
            XCTAssertNotNil(data)
        }) { (error : NSError) in
            XCTAssertFalse(true, "should not throw error even in case of failures")
        }
    }
}
