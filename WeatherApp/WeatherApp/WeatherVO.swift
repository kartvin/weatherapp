//
//  WeatherVO.swift
//  WeatherApp
//
//  Created by Karthik Kumaravel on 5/10/17.
//  Copyright © 2017 Karthik Kumaravel. All rights reserved.
//

import Foundation
class WeatherVO : NSObject {
    //Initialization with default values to avoid NPE
    var id:Int = 0
    var main :String = ""
    var weatherDescription :String = ""
    var icon :String = ""
    var iconUrl :String = ""
}
