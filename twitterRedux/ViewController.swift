//
//  ViewController.swift
//  twitterRedux
//
//  Created by vr on 10/4/14.
//  Copyright (c) 2014 vr. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - UI Outlets
    @IBOutlet weak var contentViewXalignment: NSLayoutConstraint!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        hideHamburgerMenu()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Sliding adjustment for Content View
    func showHamburgerMenu() {
        // TODO: move 300 to constants
        self.contentViewXalignment.constant = -180;
    }
    
    func hideHamburgerMenu() {
        contentViewXalignment.constant = 0
    }
    
    func isHamburgerMenuVisible() -> Bool {
        return contentViewXalignment.constant != 0
    }
    
    @IBAction func showHideMenu(sender: UIButton) {
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

