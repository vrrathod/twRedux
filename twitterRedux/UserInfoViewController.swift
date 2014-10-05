//
//  UserInfoViewController.swift
//  twitterRedux
//
//  Created by vr on 10/4/14.
//  Copyright (c) 2014 vr. All rights reserved.
//

import UIKit

class UserInfoViewController: UIViewController {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var tweetCount: UILabel!
    @IBOutlet weak var followerCount: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    
    var itweetCount:NSInteger = 0
    var ifollowers:NSInteger = 0
    var ifollowing:NSInteger = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setInfoWithTimer()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setInfoWithTimer() {
        NSLog("setting info")
        backgroundImage.image = TwitterClient.sharedClient.userBackgroundImage()
        profileImage.image = TwitterClient.sharedClient.userImage()
        (itweetCount, ifollowers, ifollowing) = TwitterClient.sharedClient.userStats();
        
        tweetCount.text = "\(itweetCount)\nTweets"
        tweetCount.sizeToFit()
        followerCount.text = "\(ifollowers)\nFollowers"
        followerCount.sizeToFit()
        followingCount.text = "\(ifollowing)\nFollowing"
        followingCount.sizeToFit()
        
        if backgroundImage.image == nil || profileImage.image == nil {
            NSLog("scheduling timer")
            NSTimer.scheduledTimerWithTimeInterval(30.0, target: self, selector: "setImagesWithTimer", userInfo: nil, repeats: false)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
