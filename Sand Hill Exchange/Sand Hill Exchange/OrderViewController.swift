//
//  OrderViewController.swift
//  Sand Hill Exchange
//
//  Created by Elaine Ou on 4/23/15.
//  Copyright (c) 2015 Sand Hill Exchange. All rights reserved.
//

import UIKit

let ORDER_URL: String = BASE_URL + "/trade/order"
let MARKET_PRICE: Float = 9999.99
let MARKET_SELL: Float = 0.0

class OrderViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate  {
    
    var company = Company()
    var buySell = Bool()  // true if buy, false if sell
    var storedKey = String()
    var order = Order()
    
    @IBOutlet weak var orderSummary: UITextView!
    
    var price : Float = 0.0
    var qty : Float = 0.0
    var marketLimit :Bool = true //true when market price
    
    @IBOutlet weak var buySellLabel: UILabel!
    
    @IBOutlet weak var orderForm: UITableView!

    @IBOutlet weak var submitBtn: UITextView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var reviewBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    
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
        orderSummary.textContainerInset = UIEdgeInsets(top: 0, left: CGFloat(10), bottom: 0, right: CGFloat(10))
        
        // hide edit button until review order
        editBtn.hidden = true
        reviewBtn.hidden = true
    }
    
    @IBAction func editOrder(sender: AnyObject) {
        //show keyboard again
        var idx = NSIndexPath(forRow: 0, inSection: 0)
        let qtyCell = orderForm.cellForRowAtIndexPath(idx) as! QtyCell
        qtyCell.qtyField.becomeFirstResponder()
        editBtn.hidden = true
        closeBtn.hidden = false
    }
    
    @IBAction func qtyField(sender: AnyObject) {
        updateCost()
    }

    @IBAction func priceField(sender: AnyObject) {
        updateCost()
    }

    @IBAction func marketLimitBtn(sender: AnyObject) {
        // toggle between market and limit
        marketLimit = !marketLimit
        var idp = NSIndexPath(forRow: 0, inSection: 1)
        let priceCell = orderForm.cellForRowAtIndexPath(idp) as! PriceCell
        if marketLimit {
            priceCell.marketLimit.setTitle("Market Price", forState: UIControlState.Normal)
            priceCell.priceField.text = NSString(format: "%.2f", company.quote.lastPrice) as String!
            priceCell.priceField.userInteractionEnabled = false
            priceCell.priceField.resignFirstResponder()
            var idx = NSIndexPath(forRow: 0, inSection: 0)
            let qtyCell = orderForm.cellForRowAtIndexPath(idx) as! QtyCell
            qtyCell.qtyField.becomeFirstResponder()
            updateCost()
        } else {
            priceCell.marketLimit.setTitle("Limit Price", forState: UIControlState.Normal)
            priceCell.priceField.userInteractionEnabled = true
        }
    }
    

    @IBAction func reviewBtn(sender: AnyObject) {
        // create order
        order.companyKey = company.key
        order.symbol = company.symbol
        order.qty = Int(qty)
        order.bidAsk = buySell
        order.market = marketLimit
        if marketLimit {
            if buySell { order.price = MARKET_PRICE }
            else { order.price = MARKET_SELL }
        } else {
            order.price = price
        }
        
        // update summary
        var mlstring = "market"
        var marketstring = " will be executed at the best available price."
        if !marketLimit {
            mlstring = "limit"
            marketstring = ", if executed, will execute at $\(price) or better."
        }
        var bsstring = "buy"
        if !buySell {bsstring = "sell"}
        
        orderSummary.text = "You are placing a \(mlstring) order to \(bsstring) \(Int(qty)) shares of \(company.symbol). Your order" + marketstring
        
        
        // dismiss keyboard for review
        var idx = NSIndexPath(forRow: 0, inSection: 0)
        
        let qtyCell = orderForm.cellForRowAtIndexPath(idx) as! QtyCell
        qtyCell.qtyField.resignFirstResponder()
        
        var idp = NSIndexPath(forRow: 0, inSection: 1)
        let priceCell = orderForm.cellForRowAtIndexPath(idp) as! PriceCell
        priceCell.priceField.resignFirstResponder()
        
        // show edit button in case they want to change
        editBtn.hidden = false
        closeBtn.hidden = true
        
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
            // default to market price
            cell.priceField.text = NSString(format: "%.2f", company.quote.lastPrice) as String!
            cell.priceField.userInteractionEnabled = false
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
        
        if (estCost != 0.0) {
            reviewBtn.hidden = false
        }
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
