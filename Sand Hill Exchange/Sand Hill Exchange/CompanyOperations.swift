//
//  CompanyOperations.swift
//  Sand Hill Exchange
//
//  Created by Elaine Ou on 5/16/15.
//  Copyright (c) 2015 Sand Hill Exchange. All rights reserved.
//

import Foundation
import UIKit

// This enum contains all the possible states a photo record can be in

class PhotoRecord {
    let name:String
    let url:NSURL
    var state = PhotoRecordState.New
    var image = UIImage(named: "Placeholder")
    
    init(name:String, url:NSURL) {
        self.name = name
        self.url = url
    }
}