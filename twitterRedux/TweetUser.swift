//
//  TweetUser.swift
//  twitterRedux
//
//  Created by vr on 10/5/14.
//  Copyright (c) 2014 vr. All rights reserved.
//

import Foundation

class TweetUser {
    private var userData:NSDictionary = NSDictionary();

    
    func setUserData( userInfo : NSDictionary ) {
        userData = userInfo
    }
    
    // MARK: - Private
    
    // Generic Getter for string
    private func stringForAttribute( attr:String ) -> String {
        var out = userData[attr] as? String
        if( nil != out ) {
            return out!
        } else {
            return "" // TODO: check if to use "" or nil
        }
    }
    
    // Generic Getter for number
    private func numberStringForAttribute( attr:String ) -> String {
        if let out = userData[attr] as NSNumber? {
            return "\(out)"
        } else {
            return "" // TODO: check if to use "" or nil
        }
    }
    
    private func integerForAttribute( attr:String ) -> NSInteger {
        var retVal:NSInteger = NSInteger.min
        if let out = userData[attr] as NSNumber? {
            retVal = out.integerValue
        } else {
            NSLog("We have a problem, Houston!");
            //TODO: throw exception
        }
        return retVal
    }
    
    
    
    //MARK: - getters
    
    func tweetCountString() -> String {
        return numberStringForAttribute("statuses_count");
    }
    
    func tweetCount() -> NSInteger {
        return integerForAttribute("statuses_count")
    }
    
    func followerCountString() -> String {
        return numberStringForAttribute("followers_count");
    }
    
    func followerCount() -> NSInteger {
        return integerForAttribute("followers_count");
    }
    
    func followingCountString() -> String {
        return numberStringForAttribute("friends_count");
    }
    
    func followingCount() -> NSInteger {
        return integerForAttribute("friends_count");
    }
    
    func userImageURL() -> NSURL {
        return NSURL( string:stringForAttribute("profile_image_url") );
    }
    
    func userBackgroundImageURL() -> NSURL {
        return NSURL( string:stringForAttribute("profile_background_image_url") ) ;
    }
}