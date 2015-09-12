//
//  FacebookFeedQuery.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 9/2/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//
import FBSDKLoginKit
import SwiftyJSON

private let kGraphPathPIMagazineFeedString = "1384548091800506/feed"

protocol FacebookFeedQueryDelegate {
    func didFinishGettingFacebookFeedData(fbFeedObjectsArray: [FBFeedObject])
}

class FacebookFeedQuery: FacebookQuery {
    
    static let sharedInstance = FacebookFeedQuery()
    var delegate: FacebookFeedQueryDelegate?
    var FBFeedObjectsArray = [FBFeedObject]()
    
    func getFeedFromPIMagazine(errorCompletionBlock: ((error: NSError!) -> Void)? ) {
        let params = [
            "access_token": kAppAccessToken,
            "fields": "type, message, created_time"
        ]
        super.getFBDataJSON(kGraphPathPIMagazineFeedString,
            params: params,
            onSuccess: { (feedJSON) -> Void in
                let feedObjectArray = feedJSON["data"].arrayValue
                print(feedObjectArray)
                for object:JSON in feedObjectArray {
                    let newFeedObject = FBFeedObject(
                        id: object["id"].stringValue,
                        message: object["message"].stringValue,
                        created_time: object["created_time"].stringValue
                    )
                    self.FBFeedObjectsArray.append(newFeedObject)
                }
            self.delegate?.didFinishGettingFacebookFeedData(self.FBFeedObjectsArray)
        }, onError: { (error) -> Void in
            if let errorCompletion = errorCompletionBlock {
                errorCompletion(error: error)
            }
        })
    }
    
}