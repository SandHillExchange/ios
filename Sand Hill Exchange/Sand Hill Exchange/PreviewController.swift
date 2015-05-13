//
//  PreviewController.swift
//  Sand Hill Exchange
//
//  Created by Elaine Ou on 5/10/15.
//  Copyright (c) 2015 Sand Hill Exchange. All rights reserved.
//

import UIKit

class PreviewController: UIViewController {

    var testString:NSString!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println(self.testString)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func submitBtn(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {});
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
