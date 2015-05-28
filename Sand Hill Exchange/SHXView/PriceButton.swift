//
//  PriceButton.swift
//  Sand Hill Exchange
//
//  Created by Elaine Ou on 5/20/15.
//  Copyright (c) 2015 Sand Hill Exchange. All rights reserved.
//

import Foundation
import UIKit
import SHXView

class PriceButton: UIButton {

    var price :String = "$0.00"
    var change : String = "0.00%"
    var isChange : Bool = false
    
    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 4.0;
        //self.layer.borderColor = UIColor.redColor().CGColor
        //self.layer.borderWidth = 1.5
        self.backgroundColor  = UIColor(red:0.0, green:1.0, blue:0.6, alpha:1.0)
        // red = UIColor(red:1.0, green:0.31, blue:0.31, alpha:1.0)
        self.tintColor = UIColor.blackColor()
        self.selected = false
        
        // keep track of button clicks to toggle state
        self.addTarget(self, action: "buttonClicked:", forControlEvents: UIControlEvents.TouchUpInside)

        
        self.setTitle(price, forState: UIControlState.Normal)
        //self.setTitle(change, forState: UIControlState.Selected)
    }
    func buttonClicked(sender:UIButton)
    {
        isChange = !isChange
        if isChange {
           self.setTitle(change, forState: UIControlState.Normal)
        } else {
           self.setTitle(price, forState: UIControlState.Normal)
        }
    }
    func updatePrice(newPrice: Float) {
        self.price = NSString(format: "$%.3f", newPrice) as String
        self.setTitle(price, forState: UIControlState.Normal)
    }
    func updateChange(newChange: Float) {
        /*
        var formatter = NSNumberFormatter()
        formatter.numberStyle = .PercentStyle
        self.change = formatter.stringFromNumber(newChange)!
        */
        self.change = (NSString(format: "%.2f", newChange) as String) + "%" 
        self.setTitle(change, forState: UIControlState.Normal)
        
        // positive-green; negative-red
        if (newChange < 0.0) {
            self.backgroundColor  = UIColor(red:1.0, green:0.31, blue:0.31, alpha:1.0)
        }
    }
    
}
