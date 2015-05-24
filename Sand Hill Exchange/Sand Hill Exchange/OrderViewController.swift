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
    
    
    var price : Float = 0.0
    var qty : Float = 0.0
    
    @IBOutlet weak var buySellLabel: UILabel!
    
    @IBOutlet weak var orderForm: UITableView!

    
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
        
    }
    
    /*
    func updateCost() {
        qty = NSString(string: qtyCell.qtyField.text).floatValue
        price = NSString(string: priceCell.priceField.text).floatValue
        
        var estCost = qty * price
        costCell.estCostLabel.text = NSString(format: "%.2f", estCost) as String
    }*/

    @IBAction func reviewBtn(sender: AnyObject) {
        // create order
        order.companyKey = company.key
        order.symbol = company.symbol
        order.price = price
        order.qty = Int(qty)
        order.bidAsk = buySell
        
        // dismiss keyboard for review
        var qtyCell = orderForm.dequeueReusableCellWithIdentifier(qtyIdentifier) as! QtyCell
        qtyCell.qtyField.resignFirstResponder()
        var priceCell = orderForm.dequeueReusableCellWithIdentifier(priceIdentifier) as! PriceCell
        priceCell.priceField.resignFirstResponder()
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
                return cellAtIndexPath(indexPath)
    }
    func cellAtIndexPath(indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath==0 {
            let cell = orderForm.dequeueReusableCellWithIdentifier(qtyIdentifier) as! QtyCell
            cell.symbolLabel.text = company.symbol
            cell.qtyField.delegate = self
            cell.qtyField.keyboardType = UIKeyboardType.NumberPad
            
            cell.qtyField.becomeFirstResponder()
            return cell as UITableViewCell

        } else if indexPath==1 {
            let cell = orderForm.dequeueReusableCellWithIdentifier(priceIdentifier) as! PriceCell
            cell.priceField.delegate = self
            cell.priceField.keyboardType = UIKeyboardType.DecimalPad
            return cell as UITableViewCell
        } else {
            let cell = orderForm.dequeueReusableCellWithIdentifier(costIdentifier) as! CostCell
            return cell as UITableViewCell
        }
    }
    
    
    @IBAction func cancelButton(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // show confirmation

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
        
        
        // close modal
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
