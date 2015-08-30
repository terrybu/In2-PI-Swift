//
//  FacebookManager.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 8/30/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import SwiftyJSON

protocol FacebookManagerDelegate {
    func didFinishGettingFacebookPhotos(fbPhotoObjectArray: [FBPhotoObject])
}

class FacebookManager {
    
    static let sharedInstance = FacebookManager()
    var delegate: FacebookManagerDelegate?
    var FBPhotoObjectsArray = [FBPhotoObject]()
    
    func getPhotosFromFacebookAlbum() {
        var paramsDictionary = [
            "access_token": kAppAccessToken
        ]
        FBSDKGraphRequest(graphPath: "1384548091800506/albums", parameters: paramsDictionary).startWithCompletionHandler { (connection, data, error) -> Void in
            
            //Terry's test page
            //752896354818721/albums will get you the page's albums
            //757485894359767 is Untitled Album
            //757485937693096 is one image
            
            //In2 real page PI magazine
            //1384548091800506/albums will get you page's albums
            
            if (error == nil) {
                let jsonData = JSON(data)
                let albumsList = jsonData["data"]
                let firstAlbumID = albumsList[0]["id"].string
                let lastParamsDictionary = [
                    "access_token": kAppAccessToken,
                    "fields" : "photos{picture}"
                    
                ]
                FBSDKGraphRequest(graphPath: firstAlbumID, parameters: lastParamsDictionary).startWithCompletionHandler { (connection, albumPhotos, error) -> Void in
//                    println(albumPhotos)
                    let albumPhotosJSON = JSON(albumPhotos)
                    let photos = albumPhotosJSON["photos"]
                    let photosArray = photos["data"].arrayValue
                    println(photosArray.description)
                    for object:JSON in photosArray {
                        var newPicObject = FBPhotoObject(id: object["id"].string!, albumPicURLString: object["picture"].string!)
                        self.FBPhotoObjectsArray.append(newPicObject)
                    }
                    
                    if let delegate = self.delegate {
                        delegate.didFinishGettingFacebookPhotos(self.FBPhotoObjectsArray)
                    }
                }
            }
            else {
                println(error)
            }
        }
    }
    
}