//
//  Post.swift
//  weather-journal
//
//  Created by Luke Geiger on 6/29/15.
//  Copyright (c) 2015 Luke J Geiger. All rights reserved.
//

import UIKit

class Post: PFObject,PFSubclassing {
   
    /**
    The post's text.
    */
    @NSManaged var text: String
    
    /**
    The temperature of the current location of the post.
    */
    @NSManaged var temperatureF: String

    /**
    The weather of the post, Cloudy, Sunny, etc.
    */
    @NSManaged var weather: String

    /**
    The date first created.
    */
    @NSManaged var creationDate: NSDate
    
    /**
    Who made this?
    */
    @NSManaged var createdBy: PFUser


    override class func initialize() {
        
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Post"
    }
    
    
    /**
    The Display Title of the post which accounts for the date it was created
    */
    func displayTitle()-> String{
        
        var dateFormatter:NSDateFormatter = NSDateFormatter()
        
        var string = String()
        
        dateFormatter.dateFormat = "EEEE"
        var dayOfWeek = dateFormatter .stringFromDate(self.creationDate)
        
        string += dayOfWeek
        string += ", "
        
        dateFormatter.dateFormat = "MMMM"
        var month = dateFormatter .stringFromDate(self.creationDate)
        
        string += month
        string += " "
        
        dateFormatter.dateFormat = "dd"
        var dayOfMonth = dateFormatter .stringFromDate(self.creationDate)
        
        string += dayOfMonth
        
        return string
    }
    
    /**
        The day of the month in numeric form this post was created.
    */
    func dayOfMonthString()-> String{
        var dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter .stringFromDate(self.creationDate)
    }
    
    /**
        A combined string of the degrees and weather.
    */
    func weatherDisplayString()->NSString{
        var string = String()
        string += self.temperatureF
        string += " degrees"
        string += "\n"
        string += self.weather
        return string
    }
    
}
