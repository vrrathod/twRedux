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
    
    
    var userImage:UIImage?
    var userInfo:TweetUser?;
    
    func setTweetUser( userData: NSDictionary ) {
        userInfo = TweetUser();
        userInfo!.setUserData(userData)
    }
    
    func setUserImage( img:UIImage ) {
        userImage = img
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if nil == userInfo {
            userInfo = TwitterClient.sharedClient.currentUser;
        }
        
        updateInfo()
    }
    
    override func viewWillDisappear(animated: Bool) {
        userImage = nil;
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func updateInfo() {
        
        if nil == userInfo {
            NSLog("Something messed up has happend!");
            return;
        }
        
        tweetCount.text = "\(userInfo!.tweetCount())\nTweets";  tweetCount.sizeToFit()
        followerCount.text = "\(userInfo!.followerCount())\nFollowers";  followerCount.sizeToFit()
        followingCount.text = "\(userInfo!.followingCount())\nFollowing"; followingCount.sizeToFit()
        
        profileImage.image = userImage; profileImage.layoutIfNeeded()
        
        // load images
        TwitterClient.sharedClient.fetchImageFrom(userInfo!.userBackgroundImageURL(), onComplete: { (image) -> Void in
            self.backgroundImage.image = image;
            self.backgroundImage.layoutIfNeeded()
        });
        
    }
}
