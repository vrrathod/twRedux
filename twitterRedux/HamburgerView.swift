//
//  HamburgerViewController.swift
//  twitterRedux
//
//  Created by vr on 10/4/14.
//  Copyright (c) 2014 vr. All rights reserved.
//

import UIKit

class HamburgerView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Delegates as Variables
    var hamburgerHandler : HamburgerDelegate?
    var viewSwitcherHandler: ViewSwitcherDelegate?
    
    // MARK: - Delegates setters
    func setHamburgerDelegate( hamburger:HamburgerDelegate ) {
        hamburgerHandler = hamburger
    }
    
    func setViewSwitcherDelegate( viewSwitcher: ViewSwitcherDelegate ) {
        viewSwitcherHandler = viewSwitcher
    }
    
    //MARK: - TableView DataSource
    
    /*
    For now we have only so many menu items to be show. We will return a fixed number here.
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // User Profile
        // Home Timeline
        // Mentions
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(HamburgerTableViewCell.ReusableName) as HamburgerTableViewCell
        
        switch indexPath.row {
        case 0:
            cell.menuOptionName.text = "User Details"
        case 1:
            cell.menuOptionName.text = "Home Timeline"
        case 2:
            cell.menuOptionName.text = "Mentions"
        default:
            NSLog("Unsupported row \(indexPath.row)")
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        hamburgerHandler?.hideHamburgerMenu()
        
        // TODO: select appropriate view in the main view
        NSLog("switching to view at index \(indexPath.row)")
        viewSwitcherHandler?.switchToViewAtIndex(indexPath.row)
    }

}
