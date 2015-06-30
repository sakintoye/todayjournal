//
//  PostFeedTableViewController.swift
//  weather-journal
//
//  Created by Luke Geiger on 6/29/15.
//  Copyright (c) 2015 Luke J Geiger. All rights reserved.
//

import UIKit


class PostFeedTableViewController: UITableViewController {

    var posts:NSMutableArray!

    // MARK: - Life Cycle

    override func loadView() {
        super.loadView()
        self.setupInterface()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if (self.needsSignIn() == false){
            self.fetchPosts()
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.posts.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let postTableViewCell:PostTableViewCell = tableView.dequeueReusableCellWithIdentifier("postTableViewCellID", forIndexPath:indexPath) as! PostTableViewCell
        
        let post = self.posts.objectAtIndex(indexPath.row) as! Post
        
        postTableViewCell.textLabel!.text = post.displayTitle()
        postTableViewCell.detailTextLabel!.text = post.text;
        postTableViewCell.prominentLabel!.text = post.dayOfMonthString()
        postTableViewCell.prominentSubLabel!.text = post.weatherDisplayString() as String        
        return postTableViewCell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let post = self.posts.objectAtIndex(indexPath.row) as! Post

        let createPostVC = CreatePostViewController()
        createPostVC.post = post;
        self.navigationController?.pushViewController(createPostVC, animated: true)
    }
    
    // MARK: - Table view delgate
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "    Memories"
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let post = self.posts.objectAtIndex(indexPath.row) as! Post
            self.posts .removeObject(post)
            self.tableView.reloadData()
            post.deleteInBackgroundWithBlock(nil)
        }
    }
    
    // MARK: - Interface

    private func setupInterface(){
        
        self.posts = NSMutableArray()
        
        self.navigationItem.title =  self.displayTitle()

        self.tableView.registerClass(PostTableViewCell.self, forCellReuseIdentifier: "postTableViewCellID")
        
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "rightBarButtonWasPressed")
        self.navigationItem.rightBarButtonItem = rightBarButton
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.appBlueColor()
        
        if UITableView.instancesRespondToSelector("setLayoutMargins:") {
            self.tableView.layoutMargins = UIEdgeInsetsZero
            self.tableView.separatorInset = UIEdgeInsetsZero
            UITableViewCell.appearance().layoutMargins = UIEdgeInsetsZero
        }

    }
    
    private func displayTitle()-> String{
        
        var dateFormatter:NSDateFormatter = NSDateFormatter()
        
        var string = String()
        
        dateFormatter.dateFormat = "EEEE"
        var dayOfWeek = dateFormatter .stringFromDate(NSDate())
        
        string += dayOfWeek
        string += ", "
        
        dateFormatter.dateFormat = "MMMM"
        var month = dateFormatter .stringFromDate(NSDate())
        
        string += month
        string += " "
        
        dateFormatter.dateFormat = "dd"
        var dayOfMonth = dateFormatter .stringFromDate(NSDate())
        
        string += dayOfMonth
        
        return string
    }
    
    // MARK: - Actions

    func rightBarButtonWasPressed(){
        
        let createPostVC = CreatePostViewController()
        createPostVC.navigationItem.title = self.navigationItem.title
        self.navigationController?.pushViewController(createPostVC, animated: true)
    }
    
    func needsSignIn() -> Bool{
        if (PFUser.currentUser() != nil){
            return false
        }
        else{
            var onboardVC = OnboardingViewController()
            onboardVC.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
            
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.presentViewController(onboardVC, animated: true, completion: nil)
            }
            return true
        }
    }
    
    func fetchPosts(){
        
        var query = Post.query()
        query!.fromLocalDatastore();
        query!.limit = 1000;
        query!.orderByDescending("creationDate")
        query!.whereKey("createdBy", equalTo: PFUser.currentUser()!)
        
        query!.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                self.posts = NSMutableArray(array: objects!)
                self.tableView.reloadData()
            } else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }
    }

}
