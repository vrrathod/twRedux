//
//  TwitterTableViewController.swift
//  twitterRedux
//
//  Created by vr on 10/4/14.
//  Copyright (c) 2014 vr. All rights reserved.
//

import UIKit

class TwitterTableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    // User info
    var userImage:UIImage?
    var hamburgerMenu:UIBarButtonItem?
    
    // Table data
    var tableData = NSArray()
    
    // Pull handler
    var pullHandler:UIRefreshControl = UIRefreshControl();
    var isPulled = false;
    
    // MARK: - Overrides and Blocks
    
    // Block to handle completion of the tweets query
    func tweetStreamCompletionBlock( success:Bool, dataArray:NSArray!, error:NSError!) -> Void {
        if success {
//            NSLog("\(dataArray)")
            self.tableData = dataArray // TODO: infinite scrolling!
            self.tableView.reloadData()
            // Once we are done here, we know things are setup appropriately
            // let get current user's image if its not there
            self.downloadCurrentUserImage()
        } else {
            NSLog("Error! \(error?.localizedDescription)")
        }
        
        if self.isPulled{
            self.pullHandler.endRefreshing()
            self.isPulled = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        TwitterClient.sharedClient.getHomeTimeLine(tweetStreamCompletionBlock);
        
        // setup pull handler
        pullHandler.attributedTitle = NSAttributedString(string: "Pull Me!")
        pullHandler.tintColor = UIColor.redColor()
        pullHandler.addTarget(self, action: "updateTweetStream:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(pullHandler)
        
        // add hamburger menu
        var im = UIImage(named: "hamburger")
        hamburgerMenu = UIBarButtonItem(image: im, style: UIBarButtonItemStyle.Bordered, target: self, action: "didTouchHamburgerMenu")
        self.navigationItem.leftBarButtonItem = hamburgerMenu;
        
    }
    
    func downloadCurrentUserImage() {
        
        if nil != userImage {
            // We've got the image, bail out
            return
        }
        
        // let get current user's image
        let url = NSURL( string: TwitterClient.sharedClient.accountImageURL )
        NSURLSession.sharedSession().downloadTaskWithURL(url, completionHandler: { (localURL, response, error) -> Void in
            if nil != error {
                NSLog("Failed to get current user's image: \(error.localizedDescription)");
            } else {
                // We've got the url
                self.userImage = UIImage(data: NSData(contentsOfURL: localURL))
            }
        }).resume()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View Data Source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(TwitterConstant.twitterTableRowConst) as TwitterTableViewCell
        
        cell.setTweetData(tableData.objectAtIndex(indexPath.row) as NSDictionary)
        cell.sizeToFit()
        
        return cell
    }
    
    func updateTweetStream( sender: AnyObject? ) {
        self.isPulled = true;
        TwitterClient.sharedClient.getHomeTimeLine(tweetStreamCompletionBlock)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == TwitterConstant.tweetDetailsSegueName {
            let dest = segue.destinationViewController as TweetDetailsViewController
            if let cell = sender as? TwitterTableViewCell {
                dest.setTweetInfo(cell.tweetInfo)
                if let img = cell.userProfileImage.image as UIImage? {
                    dest.setUserProfilePic( img )
                }
            }
        }
//        else if segue.identifier == TwitterConstant.twitterNewTweetSegueName {
//            let dest = segue.destinationViewController as ComposeTweetViewController
//            if nil != userImage {
//                dest.setUserImage(userImage)
//            } else {
//                downloadCurrentUserImage()
//            }
//        }
    }
    
    func didTouchHamburgerMenu() {
        //NOP for now
    }


}


