//
//  HamburgerTableViewCell.swift
//  twitterRedux
//
//  Created by vr on 10/4/14.
//  Copyright (c) 2014 vr. All rights reserved.
//

import UIKit

class HamburgerTableViewCell: UITableViewCell {
    
    // MARK: - Variables
    class var ReusableName:String {
        get {
            return "vr.twitterRedux.HamburgerCell";
        }
    }
    @IBOutlet weak var menuOptionName: UILabel!

    // MARK: - Overrides
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
