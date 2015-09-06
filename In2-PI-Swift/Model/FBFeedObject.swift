//
//  FBFeedObject.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 9/2/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import Foundation

class FBFeedObject {
    
    var id: String
    var message: String
    var created_time: String
    
    init(id: String, message: String, created_time: String) {
        self.id = id
        self.message = message
        self.created_time = created_time
    }
    
}