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
    func didFinishGettingFacebookFeedData(fbFeedObjectsArray: [FBFeedArticle])
}

class FacebookFeedQuery: FacebookQuery {
    
    static let sharedInstance = FacebookFeedQuery()
    var delegate: FacebookFeedQueryDelegate?
    var FBFeedObjectsArray = [FBFeedArticle]()
    
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
                    let newFeedObject = FBFeedArticle(
                        id: object["id"].stringValue,
                        message: object["message"].stringValue,
                        created_time: object["created_time"].stringValue,
                        type: object["type"].stringValue
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
    
    func parseMessageForLabels(feedObject: FBFeedArticle, articleCategoryLabel: UILabel, articleTitleLabel: UILabel, articleDateLabel: UILabel) -> Void {
        var categoryStr = ""
        var firstTitleStr: String?
        let msg = feedObject.message
        if (!msg.isEmpty) {
            if (msg[0] == "[") {
                print("found open bracket")
                for (var i=1; i < msg.characters.count; i++) {
                    categoryStr += msg[i]
                    let j = i + 1
                    if (msg[j] == "]" || categoryStr.characters.count >= 100) {
                        firstTitleStr = parseFirstLineTitleString(msg[j+1..<msg.characters.count])
                        break
                    }
                }
            }
            articleCategoryLabel.text = categoryStr
            if let firstTitleStr = firstTitleStr {
                articleTitleLabel.text = firstTitleStr
            }
            
            articleDateLabel.text = CustomDateFormatter.sharedInstance.convertFBCreatedTimeDateToOurFormattedString(feedObject)
        }
    }
    
    private func parseFirstLineTitleString(msg: String) -> String {
        //Given a string that starts with an empty space and then a sententece followed by \n or just \n Title \n ... return thet tile.
        // " blahblahblah \n" --> should return blahblahblah
        // " \n blahblahblah \n" should also return blahblahblah
        var result = ""
        let startingStr = msg[1..<msg.characters.count]
        if (startingStr[0] == "\n") {
            //if it finds \n immediately (which means author inserted a new line between category and title, we just jump and start from the next line
            var i = 1;
            while (startingStr[i] != "\n") {
                result += startingStr[i]
                i++;
            }
        }
        else {
            //otherwise, we go right for the first line
            var i = 0;
            while (startingStr[i] != "\n") {
                result += startingStr[i]
                i++;
            }
        }
        return result
    }
    
}