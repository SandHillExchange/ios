//
//  CompanyModel.swift
//  Sand Hill Exchange
//
//  Created by Elaine Ou on 4/19/15.
//  Copyright (c) 2015 Sand Hill Exchange. All rights reserved.
//

import Foundation
import UIKit

enum CompanyState {
    case New, Downloaded, Failed
}

class Company: NSObject{
    var logoUrl: NSURL!
    var name: String!
    var key: String!
    var symbol: String!
    var quote: Quote!
    var image = UIImage(named: "Placeholder")
    var state = CompanyState.New
    // properties for PortfolioEquity
    var qty: Int!
    var avgPrice: Float!
    
    //companies.query(["completed": false], error: nil)
    func toDict() -> NSDictionary {
        return ["symbol": self.symbol, "lastPrice":self.quote.lastPrice]
    }
    
    override init() {
        /*
        self.name = name
        self.logoUrl = logoUrl
        self.key = key
        self.symbol = symbol
        self.lastPrice = lastPrice
    */
    }
    
}

struct Quote {
    var lastPrice: Float!
    var dayChange: Float!
    var volume: Int!
}

/* I changed my mind about dling images
   but just in case: http://www.raywenderlich.com/76341/use-nsoperation-nsoperationqueue-swift
*/

class PendingOperations {
    lazy var downloadsInProgress = [NSIndexPath:NSOperation]()
    lazy var downloadQueue:NSOperationQueue = {
        var queue = NSOperationQueue()
        queue.name = "Download queue"
        queue.maxConcurrentOperationCount = 1
        return queue
        }()
    
}

class ImageDownloader: NSOperation {

    let companyRecord: Company
    
    init(companyRecord: Company) {
        self.companyRecord = companyRecord
    }
    
    override func main() {

        if self.cancelled {
            return
        }
        let imageData = NSData(contentsOfURL:self.companyRecord.logoUrl)
        
        if self.cancelled {
            return
        }
        
        if imageData?.length > 0 {
            self.companyRecord.image = UIImage(data:imageData!)
            self.companyRecord.state = .Downloaded
        }
        else
        {
            self.companyRecord.state = .Failed
            self.companyRecord.image = UIImage(named: "Failed")
        }
    }
}