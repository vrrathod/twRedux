//
//  ViewSwitcherDelegate.swift
//  twitterRedux
//
//  Created by vr on 10/4/14.
//  Copyright (c) 2014 vr. All rights reserved.
//

import Foundation

// Protocol for switching views based on menu options
protocol ViewSwitcherDelegate {
    func switchToViewAtIndex( index:NSInteger )
}
