//
//  FacebookFeedQuery.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 9/2/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import SwiftyJSON

let kGraphPathPIMagazineFeedString = "1384548091800506/feed"

protocol FacebookFeedQueryDelegate {
    func didFinishGettingFacebookFeedData(fbFeedObjectsArray: [FBFeedObject])
}

class FacebookFeedQuery {
    
    static let sharedInstance = FacebookFeedQuery()
    var delegate: FacebookFeedQueryDelegate?
    var FBFeedObjectsArray = [FBFeedObject]()
    
    func getFeedFromPIMagazine() {
        var params = [
            "access_token": kAppAccessToken,
            "fields": "type, message, created_time"
        ]
        FBSDKGraphRequest(graphPath: kGraphPathPIMagazineFeedString, parameters: params).startWithCompletionHandler { (connection, data, error) -> Void in
            let feedJSON = JSON(data)
            let feedObjectArray = feedJSON["data"].arrayValue
            println(feedObjectArray)
            for object:JSON in feedObjectArray {
                var newFeedObject = FBFeedObject(id: object["id"].stringValue, message: object["message"].stringValue, created_time: object["created_time"].stringValue)
                self.FBFeedObjectsArray.append(newFeedObject)
            }
            self.delegate?.didFinishGettingFacebookFeedData(self.FBFeedObjectsArray)
        }
    }
}