//
//  OrderModel.swift
//  Sand Hill Exchange
//
//  Created by Elaine Ou on 4/19/15.
//  Copyright (c) 2015 Sand Hill Exchange. All rights reserved.
//

import Foundation

class Order: NSObject{
    var companyKey: String!
    var symbol: String!
    var price: Float!
    var qty: Int!
    var bidAsk: Bool!   // true = BUY, false = SELL
}