//
//  SHXView.swift
//  Sand Hill Exchange
//
//  Created by Elaine Ou on 5/20/15.
//  Copyright (c) 2015 Sand Hill Exchange. All rights reserved.
//
// This custom view exposes properties that I want to edit in attributes inspector

import UIKit

@IBDesignable class SHXView: UIView {
    @IBInspectable var borderColor: UIColor = UIColor.clearColor() {
        didSet {
            layer.borderColor = borderColor.CGColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
}
