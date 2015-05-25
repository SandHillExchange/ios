//
//  OrderViewController.swift
//  Sand Hill Exchange
//
//  Created by Elaine Ou on 4/23/15.
//  Copyright (c) 2015 Sand Hill Exchange. All rights reserved.
//

import UIKit

let ORDER_URL: String = BASE_URL + "/trade/order"

class OrderViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate  {
    
    var company = Company()
    var buySell = Bool()  // true if buy, false if sell
    var storedKey = String()
    var order = Order()
    
    @IBOutlet weak var orderSummary: UITextView!
    
    var price : Float = 0.0
    var qty : Float = 0.0
    
    @IBOutlet weak var buySellLabel: UILabel!
    
    @IBOutlet weak var orderForm: UITableView!

    @IBOutlet weak var submitBtn: UITextView!
    
    let qtyIdentifier = "qtyCell"
    let priceIdentifier = "priceCell"
    let costIdentifier = "costCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if buySell {
            buySellLabel.text = "BUY"
        } else {
            buySellLabel.text = "SELL"
        }
        orderForm.dataSource = self
        orderForm.delegate = self
        orderForm.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // get userkey
        var tempKey: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("userkey")
        if (tempKey != nil) { storedKey = tempKey as! String}
        
        var spacing:CGFloat = 60
        submitBtn.textContainerInset = UIEdgeInsets(top: spacing, left: 0, bottom: 0, right: 0)
        orderSummary.layer.cornerRadius = 10.0
    }
    
    @IBAction func qtyField(sender: AnyObject) {
        updateCost()
    }

    @IBAction func priceField(sender: AnyObject) {
        updateCost()
    }

    

    @IBAction func reviewBtn(sender: AnyObject) {
        // create order
        order.companyKey = company.key
        order.symbol = company.symbol
        order.price = price
        order.qty = Int(qty)
        order.bidAsk = buySell
        
        // update summary
        orderSummary.text = "You are placing an (market/limit) order to buy %d share(s) of %s. Your order will be (placed after the market opens and) executed at the best available price."
        
        
        // dismiss keyboard for review
        var idx = NSIndexPath(forRow: 0, inSection: 0)
        
        let qtyCell = orderForm.cellForRowAtIndexPath(idx) as! QtyCell
        qtyCell.qtyField.resignFirstResponder()
        
        var idp = NSIndexPath(forRow: 0, inSection: 1)
        let priceCell = orderForm.cellForRowAtIndexPath(idp) as! PriceCell
        priceCell.priceField.resignFirstResponder()
        
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
                return cellAtIndexPath(indexPath)
    }
    func cellAtIndexPath(indexPath: NSIndexPath) -> UITableViewCell {
        switch (indexPath.section) {
        case 0:
            let cell = orderForm.dequeueReusableCellWithIdentifier(qtyIdentifier) as! QtyCell
            cell.symbolLabel.text = company.symbol
            cell.qtyField.delegate = self
            cell.qtyField.keyboardType = UIKeyboardType.NumberPad
            
            cell.qtyField.becomeFirstResponder()
            return cell as UITableViewCell
        case 1:
            let cell = orderForm.dequeueReusableCellWithIdentifier(priceIdentifier) as! PriceCell
            cell.priceField.delegate = self
            cell.priceField.keyboardType = UIKeyboardType.DecimalPad
            return cell as UITableViewCell
        default:
            let cell = orderForm.dequeueReusableCellWithIdentifier(costIdentifier) as! CostCell
            cell.estCostLabel.text = "$0.00"
            return cell as UITableViewCell
        }
    }
    
    func updateCost() {
        
        var idx = NSIndexPath(forRow: 0, inSection: 0)
        
        let qtyCell = orderForm.cellForRowAtIndexPath(idx) as! QtyCell
        qty = NSString(string: qtyCell.qtyField.text).floatValue
        
        var idp = NSIndexPath(forRow: 0, inSection: 1)
        let priceCell = orderForm.cellForRowAtIndexPath(idp) as! PriceCell
        price = NSString(string: priceCell.priceField.text).floatValue
        
        var estCost = qty * price
        println(estCost)
        var idc = NSIndexPath(forRow: 0, inSection: 2)
        let costCell = orderForm.cellForRowAtIndexPath(idc) as! CostCell
        costCell.estCostLabel.text = NSString(format: "%.2f", estCost) as String
    }
    

    @IBAction func swipeSubmit(sender: AnyObject) {
            println("swipe")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // show confirmation
        if (segue.identifier == "confirmOrder") {

            var err: NSError?
            var params = ["symbol":order.symbol, "bidask":order.bidAsk, "price":order.price, "qty":String(order.qty)]
            
            var url = NSURL(string: ORDER_URL)
            var request = NSMutableURLRequest(URL: url!)
            request.HTTPMethod = "POST"
            
            request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            var session = NSURLSession.sharedSession()
            var task = session.dataTaskWithRequest(request) {
                data, response, error in
                var ok = false
                var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Body: \(strData)")
                var err: NSError?
                var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
                
                // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
                if(err != nil) {
                    println(err!.localizedDescription)
                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("Error could not parse JSON: '\(jsonStr)'")
                }
                else {
                    println(json)
                    if let parseJSON = json {
                        var status = parseJSON["status"] as? String
                        if (status=="ok") {
                            
                        }
                    }
                    else {
                        let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                        println("Error could not parse JSON: \(jsonStr)")
                    }
                }
            }
            
            task.resume()
        } else if (segue.identifier == "cancelOrder") {
            println("cancel")
        }
        
        
        // close modal
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
