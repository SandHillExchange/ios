//
//  CompanyViewController.swift
//  Sand Hill Exchange
//
//  Created by Elaine Ou on 4/19/15.
//  Copyright (c) 2015 Sand Hill Exchange. All rights reserved.
//

import UIKit

class CompanyViewController: UIViewController {

    var company = Company()
    //let pendingOperations = PendingOperations()
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var logoImage: UIImageView!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var changeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println(company.quote.dayChange)
        nameLabel.text = company.name
        priceLabel.text = NSString(format: "$%.3f", company.quote.lastPrice) as String
        var changeAbs = NSString(format: "%.3f", company.quote.dayChange * company.quote.lastPrice) as String
        changeLabel.text = changeAbs + " (" + (NSString(format: "%.2f", company.quote.dayChange*100) as String) + "%)"
        
        
        let data = NSData(contentsOfURL: company.logoUrl!) //make sure your image in this url does exist, otherwise unwrap in a if let check

        logoImage.image = UIImage(data: data!)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        // sender is the tapped `UIButton`
        let action = sender as! UIButton
        
        if let destination:OrderViewController = segue.destinationViewController as? OrderViewController {
            destination.company = company
            if let text = action.titleLabel?.text {
                if (text=="BUY") {
                    destination.buySell = true
                } else {
                    destination.buySell = false
                }
            }
        }
    }

    
    @IBAction func swipeLeft(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    /* functions from Order Modal */
    @IBAction func cancelOrder(segue:UIStoryboardSegue) {
        // canceled
        
    }
    
    @IBAction func confirmOrder(segue:UIStoryboardSegue) {
        //let vc : AnyObject! = self.storyboard!.instantiateViewControllerWithIdentifier("confirm")
        //self.showViewController(vc as! UIViewController, sender: vc)
        //presentViewController(vc, animated: true, completion: nil)
        var vc = self.storyboard?.instantiateViewControllerWithIdentifier("confirm") as! ConfirmViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
}
