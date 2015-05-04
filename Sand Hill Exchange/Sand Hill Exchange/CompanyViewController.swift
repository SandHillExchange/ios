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
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var logoImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println(company.name)
        nameLabel.text = company.name
        
        let imgString = BASE_URL + "/gcs/" + company.logoUrl
        let imgURL = NSURL(string: imgString)

        let data = NSData(contentsOfURL: imgURL!) //make sure your image in this url does exist, otherwise unwrap in a if let check

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

}
