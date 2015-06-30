//
//  Extensions.swift
//  weather-journal
//
//  Created by Luke Geiger on 6/29/15.
//  Copyright (c) 2015 Luke J Geiger. All rights reserved.
//

import Foundation


extension UIFont{
    
    class func appFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue-Thin", size: size)!
    }
    class func lightAppFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue-UltraLight", size: size)!
    }
    class func boldAppFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue-Light", size: size)!
    }
    
}

extension UIColor{
    
    class func appGreyColor() -> UIColor {
        return UIColor(red: 125/255.0, green: 125/255.0, blue: 125/255.0, alpha: 1)
    }
    class func appDarkGreyColor() -> UIColor {
        return UIColor(red: 52/255.0, green: 52/255.0, blue: 52/255.0, alpha: 1)
    }
    class func appBlueColor() -> UIColor {
        return UIColor(red: 17/255.0, green: 159/255.0, blue: 194/255.0, alpha: 1)
    }
    
}

