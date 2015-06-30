//
//  OnboardingViewController.swift
//  weather-journal
//
//  Created by Luke Geiger on 6/29/15.
//  Copyright (c) 2015 Luke J Geiger. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {

    override func loadView() {
        super.loadView()
        self.setupInterface()
    }
    
    private func setupInterface(){
     
        var lgSublimationView = LGSublimationView(frame: self.view.bounds)
     
        var introViews = NSMutableArray()
        
        for (var i  = 1; i<=2; i++) {
            var view = UIImageView(frame: self.view.bounds)
            view.image = UIImage(named: NSString(format: "%i.jpg", i) as String)
            view.contentMode = UIViewContentMode.ScaleAspectFill
            introViews.addObject(view)
        }
        
        lgSublimationView.viewsToSublime = introViews as [AnyObject]
        lgSublimationView.titleStrings = ["Hello.","Remember."]
        lgSublimationView.descriptionStrings = ["Take a moment to reflect\non something, everyday.","Relive your memories."]

        lgSublimationView.titleLabelTextColor = UIColor.whiteColor()
        lgSublimationView.descriptionLabelTextColor = UIColor.whiteColor()
        
        var shadeView = UIView(frame: self.view.bounds)
        shadeView.backgroundColor = UIColor.blackColor()
        shadeView.alpha = 0.5
        lgSublimationView.inbetweenView = shadeView
        self.view.addSubview(lgSublimationView)
        
        var joinButton:UIButton = UIButton(frame:  CGRectMake((self.view.width - (self.view.width - 100))/2, self.view.bottomY-90, self.view.width - 100, 40))
        joinButton.titleLabel?.font = UIFont.boldAppFontOfSize(14)
        joinButton.layer.borderWidth = 1;
        joinButton.clipsToBounds = true;
        joinButton.layer.cornerRadius = 2;
        joinButton.layer.borderColor = UIColor.appBlueColor().CGColor
        joinButton.setTitleColor(UIColor.appBlueColor(), forState: UIControlState.Normal)
        joinButton.setTitle("Join", forState: UIControlState.Normal)
        joinButton.addTarget(self, action: "joinButtonWasPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(joinButton)
    }
    
    func joinButtonWasPressed(){
        PFAnonymousUtils.logInWithBlock {
            (user: PFUser?, error: NSError?) -> Void in
            if error != nil || user == nil {
                println("Anonymous login failed.")
            } else {
                println("Anonymous user logged in.")
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
}
