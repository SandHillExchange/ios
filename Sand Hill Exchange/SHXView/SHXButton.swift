//
//  SHXButton.swift
//  Sand Hill Exchange
//
//  Created by Elaine Ou on 5/24/15.
//  Copyright (c) 2015 Sand Hill Exchange. All rights reserved.
//

import UIKit

class SHXButton: UIButton {

    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 4.0;
        //self.layer.borderColor = UIColor.redColor().CGColor
        //self.layer.borderWidth = 1.5
        self.backgroundColor  = UIColor(red:0.0, green:1.0, blue:0.6, alpha:1.0)
        // red = UIColor(red:1.0, green:0.31, blue:0.31, alpha:1.0)
        self.tintColor = UIColor.blackColor()
        self.selected = false
        
    }
    
    @IBInspectable var btnLabel: String = "botton" {
        didSet {
            self.setTitle(btnLabel, forState: UIControlState.Normal)
        }
    }

}
