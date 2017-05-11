//
//  ServiceManager.swift
//  WeatherApp
//
//  Created by Karthik Kumaravel on 5/10/17.
//  Copyright © 2017 Karthik Kumaravel. All rights reserved.
//

import Foundation

class ServiceManager: NSObject {
    var transactions : NSMutableArray?
    private var urls: NSDictionary?
    private let httpClient: RestClient
    
    class var sharedInstance: ServiceManager {
        struct Singleton {
            static let instance = ServiceManager()
        }
        return Singleton.instance
    }
    
    override init() {
        httpClient = RestClient()
        if let path = Bundle.main.path(forResource: "Configuration", ofType: "plist") {
            urls = NSDictionary(contentsOfFile: path)
        }
        super.init()
    }
    
    public func getCurrentWeather(city:String, completion: @escaping (_ result: WeatherResponse) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        var urlString = self.urls?["GetCurrentWeather"] as! String
        urlString = String(format: urlString, city)
        urlString = urlString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        
        makeServiceCall(urlString: urlString, completion: { (response: WeatherResponse) in
            completion(response)
        }, failure: failure)
    }
    
    public func makeServiceCall(urlString:String, completion: @escaping (_ result: WeatherResponse) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        if (!Reachability.isNetworkReachable()) {//Check for internet connection
            failure(NSError(domain: "No internet connection", code: 121, userInfo: nil))
            return
        }
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async(execute: { () -> Void in
            var request = URLRequest(url: URL(string: urlString)!)
            request.httpMethod = "GET"
            self.httpClient.makeGetRequest(request: request, completion: { (jsonResponse : NSData) in
                do {
                    //convert data to AnyObject
                    let jsonObject: AnyObject? = try JSONSerialization.jsonObject(with: jsonResponse as Data, options: []) as AnyObject
                    let response = self.parseJsonForGetCurrentWeather(response:jsonObject!)
                    if (response.code != 200) {
                        let errorMsg = response.message.isEmpty ? "Error" : response.message
                        failure(NSError(domain: errorMsg, code: response.code, userInfo: nil))
                    }
                    DispatchQueue.main.sync(execute: { () -> Void in
                        completion(response)
                    })
                }catch {
                    DispatchQueue.main.sync(execute: { () -> Void in
                        failure(NSError(domain: "Parsing Error", code: 121, userInfo: nil))
                    })
                }
            }, failure: { (error : NSError) in
                DispatchQueue.main.sync(execute: { () -> Void in
                    failure(error)//Throw general failures
                })
            })
        })
    }
    
    //This method will parse the json and save in WeatherVO and WeatherResponse
    //Only required fields are saved into the object
    private func parseJsonForGetCurrentWeather (response:AnyObject) -> WeatherResponse{
        
        var weatherList:Array<WeatherVO> = []
        let responseObject = WeatherResponse()
        
        
        if  response is NSDictionary {
            responseObject.code =  (response["cod"] as AnyObject? as? Int) ?? 0
            responseObject.name =  ((response["name"] as AnyObject? as? NSString) ?? "") as String
            
            guard let weathers = response["weather"] else {
                return responseObject
            }
            for weathersItem in weathers as! Array<AnyObject>{
                let main = (weathersItem["main"] as AnyObject? as? NSString) ?? ""
                let desc = (weathersItem["description"] as AnyObject? as? NSString) ?? ""
                let icon = (weathersItem["icon"] as AnyObject? as? NSString) ?? ""
                
                let weather:WeatherVO = WeatherVO()
                weather.main = main as String
                weather.weatherDescription = desc as String
                weather.icon = icon as String
                if (!weather.icon.isEmpty) {
                    var urlString = self.urls?["GetIcon"] as! String
                    urlString = String(format: urlString, weather.icon)
                    
                    weather.iconUrl = urlString
                }
                weather.id = (weathersItem["id"]  as AnyObject? as? Int) ?? 0
                
                weatherList.append(weather)
            }
            responseObject.weatherList = weatherList
            guard let mainResult = response["main"] as AnyObject? else {
                return responseObject
            }
            let temp = mainResult["temp"] ?? 0.0
            let pressure = mainResult["pressure"] ?? 0.0
            let humidity = mainResult["humidity"] ?? 0.0
            let temp_min = mainResult["temp_min"] ?? 0.0
            let temp_max = mainResult["temp_max"] ?? 0.0
            
            responseObject.temp = temp as! Float
            responseObject.pressure = pressure as! Float
            responseObject.humidity = humidity as! Float
            responseObject.temp_min = temp_min as! Float
            responseObject.temp_max = temp_max as! Float
        }
        return responseObject
    }
}
