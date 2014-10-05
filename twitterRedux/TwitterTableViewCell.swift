//
//  TwitterTableViewCell.swift
//  codepath.twitter
//
//  Created by vr on 9/28/14.
//  Copyright (c) 2014 vr. All rights reserved.
//

import UIKit

class TwitterTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userHandle: UILabel!
    @IBOutlet weak var tweet: UILabel!
    @IBOutlet weak var userProfileImage: UIImageView!
    
    var tweetInfo:Tweet = Tweet()

    
    // MARK: - Overrides
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    // MARK: - Set Data
    func setTweetData( tweetData:NSDictionary ) {
        tweetInfo.setTweetData(tweetData)
        
        userName.text = tweetInfo.userName()
        userName.sizeToFit()
        
        userHandle.text = "@\(tweetInfo.userHandle())"
        userHandle.sizeToFit()
        
        tweet.text = tweetInfo.tweetText()
        tweet.sizeToFit()
        
        setUserProfilePic(tweetInfo.userProfilePicURL())
    }
    
    // MARK: - Profile Pic
    func imageDownloadCompletion( location:NSURL!, response:NSURLResponse!, error:NSError!) -> Void {
        if( nil == error ) {
            dispatch_async(dispatch_get_main_queue(), {
                self.userProfileImage.image = UIImage(data: NSData(contentsOfURL: location));
                self.userProfileImage.setNeedsLayout();
            });
        } else {
            NSLog("downloading image failed \(location)");
        }
    }
    
    func setUserProfilePic( url:NSURL ) {
        //TODO: instead of blindly downloading images,
        // we could create a local image store in core data and load only unavailable images
        // ==> reduced traffic / data
        NSURLSession.sharedSession().downloadTaskWithURL(url, completionHandler: imageDownloadCompletion).resume()
    }

}
