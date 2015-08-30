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

let GraphPathPIMagazineFBAlbums = "1384548091800506/albums"

protocol FacebookManagerDelegate {
    func didFinishGettingFacebookPhotos(fbPhotoObjectArray: [FBPhotoObject])
}

class FacebookManager {
    
    static let sharedInstance = FacebookManager()
    var delegate: FacebookManagerDelegate?
    var FBPhotoObjectsArray = [FBPhotoObject]()
    
    func getNormalSizePhotoURLStringFrom(fbObject: FBPhotoObject, completion: ((normImgUrlString: String) -> Void)?) {
        var paramsDictionary = [
            "access_token": kAppAccessToken,
        ]
        let graphPathString = "\(fbObject.id)/picture?type=normal&redirect=false"
        FBSDKGraphRequest(graphPath: graphPathString, parameters: paramsDictionary).startWithCompletionHandler { (connection, data, error) -> Void in
            if (error == nil) {
//                println(data)
                let jsonData = JSON(data)
                let object = jsonData["data"]
                let url = object["url"]
                if let completion = completion {
                    completion(normImgUrlString: url.stringValue)
                }
            } else {
                println(error)
            }
        }
    }
    
    func getPhotosFromPIMagazineFBAlbum() {
        var paramsDictionary = [
            "access_token": kAppAccessToken
        ]
        FBSDKGraphRequest(graphPath: GraphPathPIMagazineFBAlbums, parameters: paramsDictionary).startWithCompletionHandler { (connection, data, error) -> Void in
            if (error == nil) {
                let jsonData = JSON(data)
                let albumsList = jsonData["data"]
                let firstAlbumID = albumsList[0]["id"].stringValue
                let firstAlbumParamsDictionary = [
                    "access_token": kAppAccessToken,
                    "fields" : "photos.limit(50){picture}",
                ]
                println(albumsList)
                println(firstAlbumID)
                FBSDKGraphRequest(graphPath: firstAlbumID, parameters: firstAlbumParamsDictionary).startWithCompletionHandler { (connection, albumPhotos, error) -> Void in
//                    println(albumPhotos)
                    let albumPhotosJSON = JSON(albumPhotos)
                    let photos = albumPhotosJSON["photos"]
                    let photosArray = photos["data"].arrayValue
//                    println(photosArray.description)
                    for object:JSON in photosArray {
                        var newPicObject = FBPhotoObject(id: object["id"].stringValue, albumPicURLString: object["picture"].stringValue)
                        self.FBPhotoObjectsArray.append(newPicObject)
                    }
                    if let delegate = self.delegate {
                        delegate.didFinishGettingFacebookPhotos(self.FBPhotoObjectsArray)
                    }
                }
            } else {
                println(error)
            }
        }
    }
    
    

}