//
//  WeatherResponse.swift
//  WeatherApp
//
//  Created by Karthik Kumaravel on 5/10/17.
//  Copyright © 2017 Karthik Kumaravel. All rights reserved.
//

import Foundation
class WeatherResponse : NSObject {
    //Initialization with default values to avoid NPE
    var code:Int = 0
    var message :String = ""
    var temp :Float = 0
    var pressure :Float = 0
    var humidity :Float = 0
    
    var temp_min :Float = 0
    var temp_max :Float = 0
    var name :String = ""
    var weatherList: [WeatherVO] = []
    
}
