//
//  AppDelegate.swift
//  weather-journal
//
//  Created by Luke Geiger on 6/29/15.
//  Copyright (c) 2015 Luke J Geiger. All rights reserved.
//

import UIKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let feedVC = PostFeedTableViewController(style:UITableViewStyle.Grouped);
        let feedNavVC = UINavigationController(rootViewController: feedVC)
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = feedNavVC
        self.window?.makeKeyAndVisible()
        
        self.parse()
        self.appearance()
        
        return true
    }
    
    func parse(){        
        // Initialize Parse.
        Parse.enableLocalDatastore()    
        Parse.setApplicationId("bh4nFLofME26mZkgykMiMMrbI3JSZBBYN5QGBFLb",
            clientKey: "wdghvXEe1o9ZCH5OdedU2krD5qk7zi5v7BeC5ema")
        Post.registerSubclass()
    }
    
    func appearance(){
        var navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.titleTextAttributes = [NSFontAttributeName:UIFont.boldAppFontOfSize(16)]
        
        var barButtonApperance = UIBarButtonItem.appearance()
        barButtonApperance.setTitleTextAttributes( [NSFontAttributeName:UIFont.appFontOfSize(16),
                                                    NSForegroundColorAttributeName:UIColor.appBlueColor()]
                                                    ,forState: UIControlState.Normal)

    
//        NSDictionary *barFont = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor hmDeepBlueColor], NSForegroundColorAttributeName,[UIFont hmFont:14], NSFontAttributeName, nil];
//        [[UIBarButtonItem appearance] setTitleTextAttributes:barFont forState:
        
        
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

