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
let PORTFOLIO_URL: String = BASE_URL + "/portfolio/json"

class ViewController: UIViewController {

    var companies = [Company]()
    var holdings = [Company]()
    var fetchDone = false
    
    @IBOutlet weak var liquidLabel: UILabel!
    
    @IBAction func marketBtn(sender: UIButton) {
        if fetchDone {
            self.performSegueWithIdentifier("marketSegue", sender: self.companies)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // start out with previously-stored portfolio
        let storedPortfolio: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("portfolio")
        
        // download portfolio info while view is loading
        getPortfolio()
        
        // download market data while view is loading
        getMarketData()
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
    
    func getPortfolio() {
        let url = NSURL(string: PORTFOLIO_URL)!
        let request = NSURLRequest(URL: url)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {response,data,error in
            if data != nil {
                /* 5 - Success! Parse the data */
                var parsingError: NSError? = nil
                let parsedResult: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError)
                
                if let liquidVal = parsedResult.valueForKey("liquid_val") as? String {
                    self.liquidLabel.text = liquidVal
                    if let portfolioDict = parsedResult.valueForKey("portfolio") as? NSArray {
                        
                        for p in portfolioDict {
                            var c = Company()
                            var logoUrl = NSURL(string:BASE_URL + (p["logo"] as! String))
                            c.logoUrl = logoUrl
                            c.symbol = p["symbol"] as! String
                            c.qty = p["qty"] as! Int
                            c.avgPrice = (p["avg_price"] as! NSString).floatValue
                            c.quote = Quote(lastPrice: (p["last_price"] as! NSString).floatValue, dayChange: (p["day_change"] as! NSString).floatValue, volume: 0)
                            self.holdings.append(c)
                        }
                    }
                    
                } else {
                    println("Cant find key 'data' in \(parsedResult)")
                }
            }
            
            if error != nil {
                let alert = UIAlertView(title:"Oops!",message:error.localizedDescription, delegate:nil, cancelButtonTitle:"OK")
                alert.show()
            }
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
    
    
    
    func getMarketData() {
        //let session = NSURLSession.sharedSession()
        let url = NSURL(string: MARKET_URL)!
        let request = NSURLRequest(URL: url)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {response,data,error in
            if data != nil {
                /* 5 - Success! Parse the data */
                var parsingError: NSError? = nil
                let parsedResult: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError)
                
                //println(parsedResult)
                if let marketDictionary = parsedResult.valueForKey("data") as? NSArray {
                    
                    for m in marketDictionary {
                        var c = Company()
                        var logoUrl = NSURL(string:BASE_URL + "/gcs/" + (m[0] as! String))
                        c.logoUrl = logoUrl
                        c.key = m[1] as! String
                        c.symbol = m[2] as! String
                        c.name = m[3] as! String
                        c.quote = Quote(lastPrice: m[4] as! Float, dayChange: m[6] as! Float, volume: m[7] as! Int)
                        self.companies.append(c)
                    }
                    self.fetchDone = true
                    
                } else {
                    println("Cant find key 'data' in \(parsedResult)")
                }
            }
            
            if error != nil {
                let alert = UIAlertView(title:"Oops!",message:error.localizedDescription, delegate:nil, cancelButtonTitle:"OK")
                alert.show()
            }
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
        
        /*
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
                        var logoUrl = NSURL(string:BASE_URL + "/gcs/")
                        c.logoUrl = logoUrl
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
    */
  }


}

