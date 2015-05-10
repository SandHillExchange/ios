//
//  OrderViewController.swift
//  Sand Hill Exchange
//
//  Created by Elaine Ou on 4/23/15.
//  Copyright (c) 2015 Sand Hill Exchange. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController {
    
    var company = Company()
    var buySell = Bool()  // true if buy, false if sell
    var storedKey = String()

    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var estCostLabel: UILabel!

    @IBAction func qtyField(sender: UITextField) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // get userkey
        var tempKey: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("userkey")
        if (tempKey != nil) { storedKey = tempKey as! String}
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
