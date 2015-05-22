//
//  RoundButton.swift
//  Sand Hill Exchange
//
//  Created by Elaine Ou on 5/21/15.
//  Copyright (c) 2015 Sand Hill Exchange. All rights reserved.
//

import UIKit

class RoundButton: UIButton {
    
    var buySellState : Bool = true
    
    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)

        self.layer.borderColor = UIColor(red:0.0, green:1.0, blue:0.6, alpha:1.0).CGColor
        self.layer.borderWidth = 1.5
        self.tintColor =  UIColor(red:0.0, green:1.0, blue:0.6, alpha:1.0)
        
        //self.frame = CGRectMake(100, 160, 60, 60)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 0.5 * self.layer.bounds.width
        println(self.layer.bounds.width)
        self.setTitle("BUY", forState: UIControlState.Normal)
        
    }
    
    @IBInspectable var buySell: Bool = true {
        didSet {
            self.buySellState = buySell
            if !buySellState {
                self.setTitle("SELL", forState: UIControlState.Normal)
                self.layer.borderColor = UIColor(red:1.0, green:0.31, blue:0.31, alpha:1.0).CGColor
                self.tintColor = UIColor(red:1.0, green:0.31, blue:0.31, alpha:1.0)
            }
        }
    }

}
