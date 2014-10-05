//
//  ViewController.swift
//  twitterRedux
//
//  Created by vr on 10/4/14.
//  Copyright (c) 2014 vr. All rights reserved.
//

import UIKit

// View controller code
class ViewController: UIViewController, HamburgerDelegate, ViewSwitcherDelegate {
    
    // MARK: - UI Outlets
    @IBOutlet weak var contentViewXalignment: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var newContentView: UIView!
    @IBOutlet weak var menuOptions: HamburgerView!
    
    // MARK: - View Collection
    var viewControllers : [UIViewController] = []
    
    
    // MARK: - overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        menuOptions.setHamburgerDelegate(self)
        menuOptions.setViewSwitcherDelegate(self)
        
        // Lets load up view controllers
        var storyBoard = UIStoryboard(name: "Main", bundle: nil);
        viewControllers.append(storyBoard.instantiateViewControllerWithIdentifier("UserInfoViewController") as UIViewController)
        viewControllers.append(storyBoard.instantiateViewControllerWithIdentifier("TwitterViewController") as UIViewController);
        
        
        hideHamburgerMenu()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Hamburger Delegate
    func showHamburgerMenu() {
        // TODO: move 300 to constants
        UIView.animateWithDuration(0.3, animations: {
            self.contentViewXalignment.constant = (0 - self.menuOptions.frame.width)
            self.view.layoutIfNeeded()
        })
    }
    
    func hideHamburgerMenu() {
        UIView.animateWithDuration(0.3, animations: {
            self.contentViewXalignment.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    
    //MARK: - View Switcher Delegate
    func switchToViewAtIndex(index: NSInteger) {
        if index < viewControllers.count {
            activeViewController = self.viewControllers[index]
        } else {
            NSLog("View not found at \(index)")
        }
    }
    
    
    //MARK: - Helper
    var activeViewController: UIViewController? {
        didSet(oldViewControllerOrNil) {
            if let oldVC = oldViewControllerOrNil {
                oldVC.willMoveToParentViewController(nil)
                oldVC.view.removeFromSuperview()
                oldVC.removeFromParentViewController()
            }
            
            if let newVC = activeViewController {
                self.addChildViewController(newVC)
                newVC.view.autoresizingMask = .FlexibleWidth | .FlexibleHeight
                self.newContentView.addSubview(newVC.view)
                newVC.didMoveToParentViewController(self)
            }
        }
    }
    
    func isHamburgerMenuVisible() -> Bool {
        return contentViewXalignment.constant != 0
    }
    
    
    //MARK: - UI Interactions
    @IBAction func showHideMenu(sender: UIBarButtonItem) {
        if isHamburgerMenuVisible() {
            hideHamburgerMenu()
        } else {
            showHamburgerMenu()
        }
    }
    
    @IBAction func didSwipe(sender: UISwipeGestureRecognizer) {
        if sender.direction == UISwipeGestureRecognizerDirection.Right {
            if !isHamburgerMenuVisible() {
                showHamburgerMenu()
            }
        } else if sender.direction == UISwipeGestureRecognizerDirection.Left {
            if isHamburgerMenuVisible() {
                hideHamburgerMenu()
            }
        }
    }
}

