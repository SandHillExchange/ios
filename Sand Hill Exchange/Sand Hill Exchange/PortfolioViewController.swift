//
//  PortfolioViewController.swift
//  Sand Hill Exchange
//
//  Created by Elaine Ou on 4/19/15.
//  Copyright (c) 2015 Sand Hill Exchange. All rights reserved.
//

import UIKit

let BASE_URL: String = "https://www.sandhill.exchange"
let MARKET_URL: String = BASE_URL + "/market/json"
let PORTFOLIO_URL: String = BASE_URL + "/portfolio/json"

class PortfolioViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var companies = [Company]()
    var holdings = [Company]()
    var fetchDone = false
    
    let marketCellIdentifier = "MarketCell"
    
    @IBOutlet weak var liquidLabel: UILabel!
    
    @IBOutlet weak var portfolioView: UITableView!
    
    @IBAction func marketBtn(sender: UIButton) {
        if fetchDone {
            self.performSegueWithIdentifier("marketSegue", sender: self.companies)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.hidden = true
        portfolioView.tableFooterView = UIView(frame:CGRectZero)
        
        // start out with previously-stored portfolio
        let storedPortfolio: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("portfolio")

        portfolioView.dataSource = self
        portfolioView.delegate = self
        portfolioView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        if(storedPortfolio != nil) {
        if let liquidVal = storedPortfolio!.valueForKey("liquid_val") as? String {
            self.liquidLabel.text = "$" + liquidVal
            
            if let portfolioDict = storedPortfolio!.valueForKey("portfolio") as? NSArray {
                self.holdings = self.createCompanies(portfolioDict)
                self.portfolioView.reloadData()
            }
        }
        }
        
        // download portfolio info while view is loading
        getPortfolio()
        
        // download market data while view is loading
        if !fetchDone {
            getMarketData()
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return holdings.count
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
            return cellAtIndexPath(indexPath)
    }
    func cellAtIndexPath(indexPath:NSIndexPath) -> MarketCell {
        let cell = portfolioView.dequeueReusableCellWithIdentifier(marketCellIdentifier) as! MarketCell
        
        let row = indexPath.row

        cell.psymbolLabel.text = holdings[row].symbol
        cell.pqtyLabel.text = String(holdings[row].qty)
        cell.ppriceLabel.updateChange(holdings[row].quote.dayChange)
        cell.ppriceLabel.updatePrice( holdings[row].quote.lastPrice)
        
        return cell
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                    self.liquidLabel.text = "$"+liquidVal

                    if let portfolioDict = parsedResult.valueForKey("portfolio") as? NSArray {
                        
                        self.holdings = self.createCompanies(portfolioDict)
                        self.portfolioView.reloadData()
                    }
                    // store for next time
                    NSUserDefaults.standardUserDefaults().setValue(parsedResult, forKey: "portfolio")
                    
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
    
    func createCompanies(portfolioDict: NSArray) -> [Company] {
        var cos = [Company]()
        
        for p in portfolioDict {
            var c = Company()
            var logoUrl = NSURL(string:BASE_URL + (p["logo"] as! String))
            c.logoUrl = logoUrl
            c.symbol = p["symbol"] as! String
            c.qty = p["qty"] as! Int
            c.avgPrice = (p["avg_price"] as! NSString).floatValue
            c.quote = Quote(lastPrice: (p["last_price"] as! NSString).floatValue, dayChange: (p["day_change"] as! NSString).floatValue, volume: 0)
            cos.append(c)
        }
        return cos
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
        
  }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "marketSegue") {
            let marketVC:MarketViewController = segue.destinationViewController as! MarketViewController
            let data = sender as! [(Company)]
            marketVC.companies = data
        } else if (segue.identifier == "companySegue") {

            // sender is the tapped `UITableViewCell`
            let cell = sender as! MarketCell
            let indexPath = self.portfolioView.indexPathForCell(cell)
            
            // load the selected model
            let item = self.holdings[indexPath!.row]
            
            if let destination:CompanyViewController = segue.destinationViewController as? CompanyViewController {
                // gonna need to pull company info from companies
                var c = companies.filter{ $0.symbol == item.symbol }.first
                destination.company = c!
            }
        }
    }


}

