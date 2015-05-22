//
//  CompanyLogo.swift
//  Sand Hill Exchange
//
//  Created by Elaine Ou on 5/21/15.
//  Copyright (c) 2015 Sand Hill Exchange. All rights reserved.
//

import UIKit

class CompanyLogo: UIImageView {
    
    @IBInspectable var width: Float = 60.0 {
        didSet {
            self.frame = CGRectMake(100, 160, CGFloat(width), CGFloat(width))
            self.layer.cornerRadius = CGFloat(0.1 * width)
            self.clipsToBounds = true
        }
    }
}
