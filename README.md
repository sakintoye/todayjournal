
# Today Journal

<p align="center">
  <img src="https://raw.githubusercontent.com/lukegeiger/todayjournal/master/screenshot.png">
</p>

A simple app where a person can blog about a few things that happen during the day. It also records weather! 

-Done in Swift. 
-Used Parse. 
-Inspired by Viacom Labs.

# Possible Improvements
- Sort the journal posts by weekly sections instead of all posts in just one section.
- Possibility to pick a mood to attach to a post such as 'Happy', 'Mad','Tired',etc.
- Option to change between farenheight and celsius temperature. 
- Further encapsulate weather fetching. As it stands, it is just a function on a view controller. It would be cool to create a weather fetching class that could be used anywhere. 

# Known Issues
- This was my first working app that was done in Swift. So I'm sure I didn't do everything perfect. If you come across an issue, please let me know so I can learn something!

# Strech Goals
- Watch App.

# Backend & Data Store
The backend of this app is Parse. For more information on how Parse works, check out their website Parse.com

# Weather Underground
For weather, I am using the Weather Underground API. I created a block function on a view controller that will return a WeatherCondition class. This class is a watered down, CocoaTouch representation, of a Condition object from the Weather Underground API. Here is what the function call looks like.

```Swift
        self.fetchWeather(){
            (result: WeatherCondition?) in
        }
```
