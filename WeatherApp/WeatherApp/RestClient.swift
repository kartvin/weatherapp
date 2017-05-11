//
//  RestClient.swift
//  WeatherApp
//
//  Created by Karthik Kumaravel on 5/10/17.
//  Copyright © 2017 Karthik Kumaravel. All rights reserved.
//

import Foundation

class RestClient {
    func makeGetRequest(request: URLRequest, completion: @escaping (NSData)->Void, failure: @escaping (NSError)->Void) {
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            guard let data = data, error == nil else{
                print("error=\(String(describing: error))")
                return
            }
            
            // check for http errors
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                print(json) // for debug
            } catch {
                print("error in JSON : \(error)")
            }
            completion(data as NSData)
        }
        task.resume()
    }
}
