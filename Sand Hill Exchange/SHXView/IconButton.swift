//
//  IconButton.swift
//  Sand Hill Exchange
//
//  Created by Elaine Ou on 5/28/15.
//  Copyright (c) 2015 Sand Hill Exchange. All rights reserved.
//

import UIKit

class IconButton: UIButton {

    
    @IBInspectable var btnString: String = "fa-bar-chart" {
        didSet {
            var buttonString = String.fontAwesomeString(btnString)
            var buttonStringAttributed = NSMutableAttributedString(string:buttonString, attributes: [NSFontAttributeName: UIFont(name: "FontAwesome", size: 30)!, NSForegroundColorAttributeName: UIColor.whiteColor()])
            
            self.titleLabel?.textAlignment = .Center
            self.setAttributedTitle(buttonStringAttributed, forState: .Normal)        }
    }
}
