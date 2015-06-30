
# Today Journal

<p align="center">
  <img src="https://raw.githubusercontent.com/lukegeiger/todayjournal/master/screenshot.png">
</p>

A simple app where a person can blog about a few things that happen during the day. It also records weather! Done in Swift. Used Parse. Inspired by Viacom Labs.

# Possible Improvements
- Sort the journal posts by weekly sections instead of all posts in just one section.
- Possibility to pick a mood to attach to a post such as 'Happy', 'Mad','Tired',etc.
- Option to change between farenheight and celsius temperature. 

# Known Issues
- This was my first working app that was done in Swift. So I'm sure I didn't do everything 100%, if you come across an issue, please let me know so I can learn something!

# Strech Goals
- Watch App.

# Backend & Data Store
The backend of this app is Parse. For more information on how Parse works, check out their website Parse.com

# Weather Underground
For weather, I am using the Weather Underground API. I created a block function that will return a WeatherCondition class. This class is a watered down, CocoaTouch representation of a Condition from the Weather Underground API. I first must get a geolocation from Weather Underground based on the users location, then I use that geolocation to query the Underground API for Conditions

```Swift
// MARK: - Wunderground API

    private func fetchWeather(completion: (result: WeatherCondition?) -> Void){
        
        //Get a GEOPointFrom Parse
        PFGeoPoint.geoPointForCurrentLocationInBackground { (geoPoint: PFGeoPoint?, error: NSError?) -> Void in

            //AFNetworking
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

```
