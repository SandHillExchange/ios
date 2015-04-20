//
//  MarketViewController.swift
//  Sand Hill Exchange
//
//  Created by Elaine Ou on 4/19/15.
//  Copyright (c) 2015 Sand Hill Exchange. All rights reserved.
//

import UIKit

let MARKET_URL: String = "https://www.b00st.vc/market/json"

class MarketViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var companies = [Company]()
    
    let marketCellIdentifier = "MarketCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    

    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
            return marketCellAtIndexPath(indexPath)
            /*
            let cell = tableView.dequeueReusableCellWithIdentifier("cell",
                forIndexPath: indexPath) as! UITableViewCell

            let row = indexPath.row
            cell.textLabel?.text = companies[row].symbol
            return cell
            */
    }
    
    func marketCellAtIndexPath(indexPath:NSIndexPath) -> MarketCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(marketCellIdentifier) as! MarketCell
        
        let row = indexPath.row
        cell.symbolLabel.text = companies[row].symbol
        cell.nameLabel.text = companies[row].name
        if let var label = companies[row].lastPrice{
            println(companies[row].lastPrice)
            cell.priceLabel.text = NSString(format: "%.2f", companies[row].lastPrice) as String
        } else { cell.priceLabel.text = "0.00" }
        return cell
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
