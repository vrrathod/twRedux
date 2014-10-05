//
//  Twitter.swift
//  codepath.twitter
//
//  Created by vr on 9/27/14.
//  Copyright (c) 2014 vr. All rights reserved.
//

import Foundation
import Social
import Accounts

class TwitterClient {
    
    let DefaultsAccountID = "TwitterAccountID"
    let DefaultsHomeTimeLine = "TwitterHomeTimeLine"
    
    let accountStore:ACAccountStore?
    let accountType:ACAccountType?
    var account:ACAccount?
    
    var accountImageURL:String = ""
    
    var urlSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration());
    
    // --- --- --- --- --- --- ---
    // MARK: - SETUP
    // --- --- --- --- --- --- ---
    
    class var sharedClient: TwitterClient {
    struct Static {
        static let instance = TwitterClient();
        }
        return Static.instance;
    }
    
    init(){
        // Read account settings from the iOS system
        accountStore = ACAccountStore()
        accountType = accountStore?.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        
        // load the id if serialized, if not make an async request
        if !deserializeAndLoadAccountID() {
            requestAccountID( true )
        } else {
            printAccount()
        }
        
        if account != nil {
            // fetch the user image
            requestAccountImageURL()
        }
    }
    
    /*
    * This function shall request account from the ACAccountStore.
    * @param withSerializtion, Bool value, if true will store accountID with DefaultsAccountID const as key
    * @return nothing
    */
    func requestAccountID( withSerialization:Bool ) {
        
        // if we have deserialized account already, we dont need to request it
        if( nil != account ) {
            NSLog("We already have account. Bailing out!")
            return
        }
        
        // well, we dont have any account, lets ask for one.
        accountStore?.requestAccessToAccountsWithType(accountType, options: nil, completion: { (found, error) -> Void in
            if found {
                let accounts = self.accountStore?.accountsWithAccountType(self.accountType?) as NSArray?
                if let lastAccount: ACAccount = accounts?.lastObject as? ACAccount {
                    self.account = lastAccount
                    NSLog("Block:Account: \(self.account)")
                    if withSerialization {
                        self.serializeAccountID()
                    }
                }
            }
        })
    }
    
    // request current user's image
    func requestAccountImageURL() {
        if nil == account {
            NSLog("Account is not setup correctly")
            return
        }

        let stringURL = "\(TwitterConstant.userInformation)\(userName())";
        let url = NSURL( string: stringURL )
        
        let authRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: url, parameters: nil)
        authRequest.account = account
        
        let request = authRequest.preparedURLRequest()

        let task = self.urlSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                NSLog(" error fetching data : \(error.localizedDescription) ")
            } else {
                if let httpResponse = response as? NSHTTPURLResponse {
                    if (httpResponse.statusCode >= 200 && httpResponse.statusCode < 300) {
                        var userInfo =
                        NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary;
                        self.accountImageURL = userInfo["profile_image_url"] as String;
                    } else {
                        NSLog("HTTP Response \(httpResponse.statusCode)");
                    }
                }
            }
        })
        
        task.resume()
    }
    
    //-------------------------------------------------------------------------------------
    // MARK: - Serialization
    //-------------------------------------------------------------------------------------
    /*
    * This function shall read the serialized account identifier. If the account identifieer is available,
    * it shall try loading the accout value.
    * @param None
    * @return Bool, true if accountID as well as a valid account associated with that ID is found.
    */
    func deserializeAndLoadAccountID() -> Bool {
        var accountID = NSUserDefaults.standardUserDefaults().valueForKey(DefaultsAccountID) as? NSString
        // if the id is available, search the store for the id
        if nil != accountID {
            account = accountStore?.accountWithIdentifier(accountID) as ACAccount?
        }
        
        // return true if account is loaded, false otherwise
        return ( nil != account)
    }
    
    /*
    * This function shall serialize account identifier for currently available account
    */
    func serializeAccountID() {
        if let accountIdentifier = account?.identifier {
            var standardDefaults = NSUserDefaults.standardUserDefaults()
            standardDefaults.setObject(accountIdentifier, forKey: self.DefaultsAccountID)
            standardDefaults.synchronize()
        }
    }
    
    func serializeHomeTimeLine( value:NSArray? ) {
        if (nil != value) {
            var standardDefaults = NSUserDefaults.standardUserDefaults()
            standardDefaults.setObject( value, forKey: DefaultsHomeTimeLine )
            standardDefaults.synchronize()
        }
    }
    
    func deSerializeHomeTimeLine() -> NSArray? {
        return NSUserDefaults.standardUserDefaults().valueForKey(DefaultsHomeTimeLine) as NSArray?;
    }
    
    // --- --- --- --- --- --- ---
    // MARK: - Util
    // --- --- --- --- --- --- ---
    func printAccount() {
        NSLog("Account = \(account)")
    }
    
    func userName() -> String {
        if self.account != nil {
            return self.account!.username
        } else {
            return "??"
        }
    }
    
    func userHandle() -> String {
        if self.account != nil {
            return self.account!.accountDescription
        } else {
            return "@??"
        }
    }
    
    func userImageURL() -> String {
        return accountImageURL
    }
    
    // --- --- --- --- --- --- ---
    // MARK: - Twitter Interaction -
    // --- --- --- --- --- --- ---
    func getHomeTimeLine( completionHandler:((Bool, NSArray!, NSError!) -> Void)? ) -> NSArray {
        var outputArray = NSArray();
        
        let url = NSURL( string: TwitterConstant.home_timeLine )
        
        let authRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: url, parameters: nil)
        authRequest.account = account
        
        let request = authRequest.preparedURLRequest()
        
        let task = self.urlSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                NSLog(" error fetching data : \(error.localizedDescription) ")
                if (nil != completionHandler) {
                    completionHandler!(false, outputArray, error)
                }
            } else {
                if let httpResponse = response as? NSHTTPURLResponse {
                    if (httpResponse.statusCode >= 200 && httpResponse.statusCode < 300) {
                        outputArray = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSArray
                        if (nil != completionHandler) {
                            completionHandler!(true, outputArray, nil)
                        }
                    } else if (nil != completionHandler) {
                        var localizedDescription:NSString = "Twitter returned \(httpResponse.statusCode)"
                        var err = NSError(domain: "Twitter", code: 0, userInfo: [NSLocalizedDescriptionKey: localizedDescription])
                        completionHandler!(false, outputArray, err);
                    }
                }
            }
        })
        
        task.resume()
        
        return outputArray;
    }
    
    func retweet( tweetId:String ) {
        var stringURL = "\(TwitterConstant.retweetURL)\(tweetId).json"
        let url = NSURL( string: stringURL )
        let authRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.POST, URL: url, parameters: nil)
        authRequest.account = account
        
        let request = authRequest.preparedURLRequest()
        
        let task = self.urlSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                NSLog("Error re-tweeting. \(error.localizedDescription)")
            } else {
                if let httpResponse = response as? NSHTTPURLResponse {
                    if (httpResponse.statusCode >= 200 && httpResponse.statusCode < 300) {
                        NSLog("retweet succeeded")
                    } else {
                        NSLog( "Twitter returned \(httpResponse.statusCode)" )
                    }
                }
            }
        })
        
        task.resume()
    }
    
    func favorite( tweetId:String ) {
        var stringURL = "\(TwitterConstant.favoriteURL)\(tweetId)"
        let url = NSURL( string: stringURL )
        let authRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.POST, URL: url, parameters: nil)
        authRequest.account = account
        
        let request = authRequest.preparedURLRequest()
        
        let task = self.urlSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                NSLog("Error favoriting!. \(error.localizedDescription)")
            } else {
                if let httpResponse = response as? NSHTTPURLResponse {
                    if (httpResponse.statusCode >= 200 && httpResponse.statusCode < 300) {
                        NSLog("favorite succeeded")
                    } else {
                        NSLog( "Fav: Twitter returned \(httpResponse.statusCode)" )
                    }
                }
            }
        })
        
        task.resume()
    }
    
    func doTweet( message:String ) {
        var localMessage = message.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet()) as String?
        if (localMessage == nil) || ( countElements(localMessage!) == 0 ) {
            //status message is empty
            return
        }
        
        var stringURL = "\(TwitterConstant.updateStatus)\(localMessage!)"
        let url = NSURL( string: stringURL)
        
        let authRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.POST, URL: url, parameters: nil)
        authRequest.account = account
        
        let request = authRequest.preparedURLRequest()
        
        let task = self.urlSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                NSLog("Error creating status!. \(error.localizedDescription)")
            } else {
                if let httpResponse = response as? NSHTTPURLResponse {
                    if (httpResponse.statusCode >= 200 && httpResponse.statusCode < 300) {
                        NSLog("status update succeeded")
                    } else {
                        NSLog( "Status update: Twitter returned \(httpResponse.statusCode)" )
                    }
                }
            }
        })
        
        task.resume()
    }
    
}