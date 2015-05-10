//
//  ViewController.swift
//  Sand Hill Exchange
//
//  Created by Elaine Ou on 4/19/15.
//  Copyright (c) 2015 Sand Hill Exchange. All rights reserved.
//

import UIKit

let BASE_URL: String = "https://www.b00st.vc"
let MARKET_URL: String = BASE_URL + "/market/json"

class ViewController: UIViewController {

    var companies = [Company]()
    var fetchDone = false
    
    @IBAction func marketBtn(sender: UIButton) {
        if fetchDone {
            self.performSegueWithIdentifier("marketSegue", sender: self.companies)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // download portfolio info while view is loading
        
        // download market data while view is loading
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0)) {
            self.getMarketData()
            dispatch_async(dispatch_get_main_queue()) {
                return
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "marketSegue") {
            let marketVC:MarketViewController = segue.destinationViewController as! MarketViewController
            let data = sender as! [(Company)]
            marketVC.companies = data
        }
    }
    func getMarketData() {
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: MARKET_URL)!
        let request = NSURLRequest(URL: url)
        
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in
            if let error = downloadError {
                println("Could not complete the request \(error)")
            } else {
                /* 5 - Success! Parse the data */
                var parsingError: NSError? = nil
                let parsedResult: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError)
                
                //println(parsedResult)
                if let marketDictionary = parsedResult.valueForKey("data") as? NSArray {
                    
                    for m in marketDictionary {
                        var c = Company()
                        c.logoUrl = m[0] as! String
                        c.key = m[1] as! String
                        c.symbol = m[2] as! String
                        c.name = m[3] as! String
                        c.lastPrice = m[4] as! Float
                        self.companies.append(c)
                    }
                    self.fetchDone = true
                    
                } else {
                    println("Cant find key 'data' in \(parsedResult)")
                }
            }
        }
        
        /* 9 - Resume (execute) the task */
        task.resume()
    }


}

