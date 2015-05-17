//
//  MarketCellTableViewCell.swift
//  Sand Hill Exchange
//
//  Created by Elaine Ou on 4/19/15.
//  Copyright (c) 2015 Sand Hill Exchange. All rights reserved.
//

import UIKit

class MarketCell: UITableViewCell {

    @IBOutlet weak var psymbolLabel: UILabel!
    @IBOutlet weak var pqtyLabel: UILabel!
    @IBOutlet weak var ppriceLabel: UILabel!
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var symbolLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
