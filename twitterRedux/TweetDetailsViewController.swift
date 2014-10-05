//
//  TweetDetailsViewController.swift
//  codepath.twitter
//
//  Created by vr on 9/28/14.
//  Copyright (c) 2014 vr. All rights reserved.
//

import UIKit

class TweetDetailsViewController: UIViewController {
    
    //MARK: UI Elements
    @IBOutlet weak private var profileImage: UIImageView!
    @IBOutlet weak private var userName: UILabel!
    @IBOutlet weak private var userHandle: UILabel!
    @IBOutlet weak private var tweetMessage: UILabel!
    @IBOutlet weak private var tweetTime: UILabel!
    @IBOutlet weak private var tweetRT: UILabel!
    @IBOutlet weak private var tweetFav: UILabel!

    
    // MARK: Private Data
    var tweetInfo:Tweet = Tweet()
    
    func setTweetInfo( tweet:Tweet ) {
        tweetInfo = tweet;
        dispatch_async(dispatch_get_main_queue(), {
            self.userName.text = self.tweetInfo.userName()
            self.userName.sizeToFit()
            
            self.userHandle.text = "@\(self.tweetInfo.userHandle())"
            self.userHandle.sizeToFit()
            
            self.tweetMessage.text = self.tweetInfo.tweetText()
            self.tweetMessage.sizeToFit()
            
            self.tweetTime.text = self.tweetInfo.tweetTime()
            self.tweetTime.sizeToFit()
            
            self.tweetRT.text = self.tweetInfo.tweetRT()
            self.tweetRT.sizeToFit()
            
            self.tweetFav.text = self.tweetInfo.favoriteCount()
            self.tweetFav.sizeToFit()
        })
    }
    
    func setUserProfilePic( pic:UIImage ){
        dispatch_async(dispatch_get_main_queue(), {
            self.profileImage.image = pic
            self.profileImage.sizeToFit()
        });
    }
    
    // MARK: overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Interactions
    @IBAction func doRetweet(sender: UIButton) {
        TwitterClient.sharedClient.retweet(tweetInfo.tweetID());
    }
    
    @IBAction func doFav(sender: AnyObject) {
        TwitterClient.sharedClient.favorite(tweetInfo.tweetID())
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
