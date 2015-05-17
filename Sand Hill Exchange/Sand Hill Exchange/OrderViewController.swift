//
//  OrderViewController.swift
//  Sand Hill Exchange
//
//  Created by Elaine Ou on 4/23/15.
//  Copyright (c) 2015 Sand Hill Exchange. All rights reserved.
//

import UIKit


class OrderViewController: UIViewController, UITextFieldDelegate {
    
    var company = Company()
    var buySell = Bool()  // true if buy, false if sell
    var storedKey = String()
    var price : Float = 0.0
    var qty : Float = 0.0

    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var estCostLabel: UILabel!

    @IBOutlet weak var priceField: UITextField!
    
    @IBOutlet weak var qtyField: UITextField!
    
    @IBAction func reviewBtn(sender: AnyObject) {
        // create order
        var order = Order()
        order.companyKey = company.key
        order.symbol = company.symbol
        order.price = price
        order.qty = Int(qty)
        
        // dismiss keyboard for review
        qtyField.resignFirstResponder()
        priceField.resignFirstResponder()
        
    }

    
    @IBAction func qtyField(sender: UITextField) {
        updateCost()
    }
    
    @IBAction func priceField(sender: UITextField) {
        updateCost()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        priceField.delegate = self
        priceField.keyboardType = UIKeyboardType.DecimalPad
        
        qtyField.delegate = self
        qtyField.keyboardType = UIKeyboardType.NumberPad
        qtyField.becomeFirstResponder()

        // get userkey
        var tempKey: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("userkey")
        if (tempKey != nil) { storedKey = tempKey as! String}
        
    }


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateCost() {
        qty = NSString(string: qtyField.text).floatValue
        price = NSString(string: priceField.text).floatValue
        
        var estCost = qty * price
        estCostLabel.text = NSString(format: "%.2f", estCost) as String
    
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        // show confirmation

        if segue.identifier == "submitOrder" {
                    // submit order
            println("submit order")
        }
        
        // close both modals
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
