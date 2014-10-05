//
//  TwitterContants.swift
//  codepath.twitter
//
//  Created by vr on 9/28/14.
//  Copyright (c) 2014 vr. All rights reserved.
//

import Foundation

class TwitterConstant {
    
    class var twitterTableRowConst:String {
        get{
            return "TwitterCell"
        }
    }
    
    class var twitterNewTweetSegueName:String {
        get {
            return "newTweet"
        }
    }
    
    class var tweetDetailsSegueName:String {
        get {
            return "showTweetDetails"
        }
    }
    
    class var home_timeLine:String {
        get{
            return "https://api.twitter.com/1.1/statuses/home_timeline.json"
        }
    }
    
    class var user_timeLine:String {
        get {
            return "https://api.twitter.com/1.1/statuses/user_timeline.json"
        }
    }
    
    class var retweetURL:String {
        get {
            return "https://api.twitter.com/1.1/statuses/retweet/"
        }
    }
    
    class var favoriteURL:String {
        get {
            return "https://api.twitter.com/1.1/favorites/create.json?id="
        }
    }
    
    class var updateStatus:String {
        get {
            return "https://api.twitter.com/1.1/statuses/update.json?status=";
        }
    }
    
    class var userInformation:String {
        get {
            return "https://api.twitter.com/1.1/users/show.json?screen_name=";
        }
    }
}