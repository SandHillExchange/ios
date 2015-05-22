//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

let button = UIButton(frame: CGRectMake(100, 160, 50, 50))
button.frame = CGRectMake(100, 160, 50, 50)
button.layer.masksToBounds = true
button.layer.cornerRadius = 0.5 * button.bounds.size.width
button.backgroundColor = UIColor.greenColor()
button.setTitle("BUY", forState: UIControlState.Normal)

button

let helloLabel = UILabel(frame: CGRectMake(0.0, 0.0, 200.0, 44.0))
helloLabel.text = str;
helloLabel.backgroundColor = UIColor.greenColor()
helloLabel.frame = CGRectMake(160, 100, 50, 50)
helloLabel.layer.masksToBounds = true
helloLabel.layer.cornerRadius = 0.5*helloLabel.frame.size.width
helloLabel