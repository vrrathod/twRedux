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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setImagesWithTimer()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setImagesWithTimer() {
        NSLog("setting images")
        backgroundImage.image = TwitterClient.sharedClient.userBackgroundImage()
        profileImage.image = TwitterClient.sharedClient.userImage()
        
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
