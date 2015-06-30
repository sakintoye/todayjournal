//
//  CreatePostViewController.swift
//  weather-journal
//
//  Created by Luke Geiger on 6/29/15.
//  Copyright (c) 2015 Luke J Geiger. All rights reserved.
//

import UIKit


class CreatePostViewController: UIViewController,UITextViewDelegate {

    var post:Post!
    private var textView:UITextView!
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInterface()
    }

    private func setupInterface(){
        
        self.view.backgroundColor = UIColor.whiteColor()

        if (self.post == nil){
            self.post = Post()
            self.post.creationDate = NSDate()
            self.post.text = "";
        }
        else{
            self.navigationItem.title = self.post.displayTitle()
        }
        
        self.fetchWeather(){
            (result: WeatherCondition?) in
            
            self.post.createdBy = PFUser.currentUser()!

            if (result != nil){
                self.post.temperatureF = result!.feelsLikeF as String
                self.post.weather = result!.weather as String
            }
            else{
                self.post.temperatureF = "-"
                self.post.weather = "Unknown"
            }
        }
    
        self.textView = UITextView(frame: CGRectMake(0, 0, self.view.width, self.view.height-216))
        self.textView?.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
        self.textView?.delegate = self;
        self.textView?.tintColor = UIColor.appBlueColor()
        self.textView.font = UIFont.appFontOfSize(14)
        self.textView.textColor = UIColor.appDarkGreyColor()
        self.textView.text = self.post!.text;
        self.view.addSubview(self.textView!)
        
        self.switchToEditingMode(true)
    }
    
    // MARK: - Actions

    override func viewWillDisappear(animated:Bool) {

        var length = count(self.textView.text)
        
        if (length > 0){
            self.post.text = self.textView.text
            self.dismissKeyboard()
            self.post.pinInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    // The object has been saved.
                } else {
                    // There was a problem, check error.description
                }
                super.viewWillDisappear(animated)
            }
            self.post.saveEventually(nil)
        }
    }
    
    private func switchToEditingMode(flag:Bool){
        if (flag == true){
           self.showKeyboard()
        }
        else{
            self.dismissKeyboard()
        }
    }
    
    func dismissKeyboard(){
        self.view.endEditing(true)
        let button: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        button.frame = CGRectMake(0, 0, 20, 20)
        button.setImage(UIImage(named:"icon-keyboard-up"), forState: UIControlState.Normal)
        button.addTarget(self, action: "showKeyboard", forControlEvents: UIControlEvents.TouchUpInside)
        var rightBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func showKeyboard(){
        self.textView.becomeFirstResponder()
        let button: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        button.frame = CGRectMake(0, 0, 20, 20)
        button.setImage(UIImage(named:"icon-keyboard-down"), forState: UIControlState.Normal)
        button.addTarget(self, action: "dismissKeyboard", forControlEvents: UIControlEvents.TouchUpInside)
        var rightBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    // MARK: - Wunderground API

    private func fetchWeather(completion: (result: WeatherCondition?) -> Void){
        
        PFGeoPoint.geoPointForCurrentLocationInBackground { (geoPoint: PFGeoPoint?, error: NSError?) -> Void in

            let manager = AFHTTPRequestOperationManager()
            
            var locationParams:NSDictionary = [
                "lat" : NSString(format:"%f", geoPoint!.latitude),
                "lng" : NSString(format:"%f", geoPoint!.longitude)
            ]
            
            let endPoint = self.weatherUnderGroundGeolookupEndpoint(locationParams)
            
            manager.GET(endPoint,
                parameters: nil,
                success: {
                    (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                    
                    let geojsonResult:NSDictionary = responseObject as! NSDictionary
                    
                    if ((geojsonResult.objectForKey("location") != nil)){
                        let locationDict = geojsonResult.objectForKey("location") as! NSDictionary
                        
                        let weatherRequestURL = locationDict.objectForKey("requesturl") as! String
                        let weatherRequestURLJson = weatherRequestURL.stringByReplacingOccurrencesOfString(".html", withString: ".json", options: NSStringCompareOptions.LiteralSearch, range: nil)
                        let conditionsEndpoint = self.weatherUnderGroundConditionsEndpoint(weatherRequestURLJson)
                        
                        manager.GET(conditionsEndpoint,
                            parameters: nil,
                            success: {
                                (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                                
                                var conditionjsonResult:NSDictionary = responseObject as! NSDictionary
                                var currentObservationDict = conditionjsonResult.objectForKey("current_observation") as! NSDictionary
                                completion(result: WeatherCondition(jsonDict: currentObservationDict))
                            },
                            failure: {
                                (operation: AFHTTPRequestOperation!,error: NSError!) in
                                println("Error:" + error.localizedDescription)
                                completion(result: nil)
                        })
                    }
                    else{
                        println("Could not get location:")
                        completion(result: nil)
                    }
                },
                failure: {
                    (operation: AFHTTPRequestOperation!,error: NSError!) in
                    println("Error:" + error.localizedDescription)
                    completion(result: nil)
            })
        }
    }
    
    private func weatherUnderGroundRootAPIString()->String{
        return "http://api.wunderground.com/api/c8d9b1271b46e705/"
    }
    
    private func weatherUnderGroundConditionsEndpoint(cityEndpoint:String)->String{
        return weatherUnderGroundRootAPIString() + "conditions/q/" + cityEndpoint
    }
    
    private func weatherUnderGroundGeolookupEndpoint(locationDict:NSDictionary)->String{
        var latString = locationDict.objectForKey("lat") as! String
        var lngString = locationDict.objectForKey("lng") as! String
        return self.weatherUnderGroundRootAPIString() + "geolookup/q/" + latString + "," + lngString + ".json"
    }
    
}
