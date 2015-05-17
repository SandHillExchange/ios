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
    var lastPrice: Float!
    var image = UIImage(named: "Placeholder")
    var state = CompanyState.New
    
    //companies.query(["completed": false], error: nil)
    
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