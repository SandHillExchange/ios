//
//  MarketViewController.swift
//  Sand Hill Exchange
//
//  Created by Elaine Ou on 4/19/15.
//  Copyright (c) 2015 Sand Hill Exchange. All rights reserved.
//

import UIKit

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
    
    @IBAction func backButton(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }

    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath) {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
            return marketCellAtIndexPath(indexPath)
    }
    
    func marketCellAtIndexPath(indexPath:NSIndexPath) -> MarketCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(marketCellIdentifier) as! MarketCell
        
        let row = indexPath.row
        cell.symbolLabel.text = companies[row].symbol
        cell.nameLabel.text = companies[row].name
        // market data diff from portfolio data (terrible)
        // so need to multiply % by 100
        cell.priceLabel.updateChange(companies[row].quote.dayChange*100)
        cell.priceLabel.updatePrice(companies[row].quote.lastPrice)
        return cell
    }
    


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "goToCompany") {
            
            // sender is the tapped `UITableViewCell`
            let cell = sender as! MarketCell
            let indexPath = self.tableView.indexPathForCell(cell)
            
            // load the selected model
            let item = self.companies[indexPath!.row]
            
            println(indexPath!.row)
            if let destination:CompanyViewController = segue.destinationViewController as? CompanyViewController {
                destination.company = item
            }
        }
    }


}
