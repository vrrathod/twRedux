//
//  Tweet.swift
//  codepath.twitter
//
//  Created by vr on 9/28/14.
//  Copyright (c) 2014 vr. All rights reserved.
//

import Foundation

class Tweet : NSObject {
    //MARK: Properties
    var tweetData:NSDictionary = NSDictionary();
    var userData:NSDictionary = NSDictionary();
    
    //MARK: Methods
    func setTweetData( data:NSDictionary ) {
        tweetData = data;
        userData = tweetData["user"] as NSDictionary;
    }
    
    // Generic Getter for string
    func stringForAttribute( attr:String, inUserData:Bool ) -> String {
        let dict = (inUserData ? userData : tweetData );
        var out = dict[attr] as? String
        if( nil != out ) {
            return out!
        } else {
            return "" // TODO: check if to use "" or nil
        }
    }
    
    // Generic Getter for number
    func numberStringForAttribute( attr:String, inUserData:Bool ) -> String {
        let dict = (inUserData ? userData : tweetData );
        if let out = dict[attr] as NSNumber? {
            return "\(out)"
        } else {
            return "" // TODO: check if to use "" or nil
        }
    }
    
    // Actual attributes
    func userName() -> String {
        return stringForAttribute("name", inUserData: true)
    }
    
    func userHandle() -> String {
        return stringForAttribute("screen_name", inUserData: true)
    }
    
    func tweetText() -> String {
        return stringForAttribute("text", inUserData: false)
    }
    
    func tweetTime() -> String {
        return stringForAttribute("created_at", inUserData: false);
    }
    
    func userProfilePicURL() -> NSURL {
        var stringURL = stringForAttribute("profile_image_url", inUserData: true);
        return NSURL(string: stringURL);
    }
    
    func tweetRT() -> String {
        var rtCount = numberStringForAttribute("retweet_count", inUserData: false);
        return "\(rtCount) RETWEETED"
    }
    
    func favoriteCount() -> String {
        var favCount = numberStringForAttribute("favorite_count", inUserData: false)
        return "\(favCount) FAVORITED"
    }
    
    func tweetID() -> String {
        return numberStringForAttribute("id", inUserData: false)
    }
        
}