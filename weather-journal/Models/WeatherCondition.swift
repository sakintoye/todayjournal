//
//  WeatherCondition.swift
//  weather-journal
//
//  Created by Luke Geiger on 6/29/15.
//  Copyright (c) 2015 Luke J Geiger. All rights reserved.
//

import UIKit

class WeatherCondition: NSObject {
 
    /**
    What the weather feels like in F.
    */
    var feelsLikeF:NSString!
    
    /**
    What the weather feels like in C.
    */
    var feelsLikeC:NSString!
    
    /**
    What the weather feels like combined with weather. (from wunderground)
    */
    var feelsLikeString:NSString!
    
    /**
    Cloudy, Rainy, Sunny, etc.
    */
    var weather:NSString!

    /**
    Takes a wunderground JSON dict representation and turns it into a cocoa touch dictionary.
    
    :param: jsonDict of wunderground condition
    
    :returns: cocoa touch wunderground weather condition
    */
    init(jsonDict : NSDictionary) {
        self.feelsLikeF = jsonDict.objectForKey("feelslike_f") as! NSString
        self.feelsLikeC = jsonDict.objectForKey("feelslike_c") as! NSString
        self.feelsLikeString = jsonDict.objectForKey("feelslike_string") as! NSString
        self.weather = jsonDict.objectForKey("weather") as! NSString
    }
    
}
