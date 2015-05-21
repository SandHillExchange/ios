//
//  MarketCellTableViewCell.swift
//  Sand Hill Exchange
//
//  Created by Elaine Ou on 4/19/15.
//  Copyright (c) 2015 Sand Hill Exchange. All rights reserved.
//

import UIKit
import SHXView

class MarketCell: UITableViewCell {

    @IBOutlet weak var psymbolLabel: UILabel!
    @IBOutlet weak var pqtyLabel: UILabel!
    @IBOutlet var ppriceLabel: PriceButton!

    
    @IBOutlet var symbolLabel: UILabel!
    @IBOutlet weak var priceLabel: PriceButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
