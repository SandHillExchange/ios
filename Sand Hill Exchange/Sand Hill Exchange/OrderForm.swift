//
//  OrderForm.swift
//  Sand Hill Exchange
//
//  Created by Elaine Ou on 5/24/15.
//  Copyright (c) 2015 Sand Hill Exchange. All rights reserved.
//

import UIKit


class QtyCell: UITableViewCell {
    @IBOutlet weak var qtyField: UITextField!
    @IBOutlet weak var symbolLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}

class PriceCell: UITableViewCell {
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var marketLimit: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

class CostCell: UITableViewCell {
    @IBOutlet weak var estCostLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}