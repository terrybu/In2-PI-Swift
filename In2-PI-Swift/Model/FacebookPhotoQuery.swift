//
//  FacebookPhotoQuery.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 8/30/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//
import FBSDKLoginKit
import SwiftyJSON

let kGraphPathPIMagazineAlbumsString = "1384548091800506/albums"
let kParamsOnlyAccessToken = [
    "access_token": kAppAccessToken
]
enum FacebookError: ErrorType {
    case Empty
}

protocol FacebookPhotoQueryDelegate {
    func didFinishGettingFacebookPhotos(fbPhotoObjectsArray: [FBPhotoObject])
}

class FacebookPhotoQuery: FacebookQuery {
    
    static let sharedInstance = FacebookPhotoQuery()
    var delegate: FacebookPhotoQueryDelegate?
    var FBPhotoObjectsArray = [FBPhotoObject]()
    
    
    func getPhotosFromMostRecentThreeAlbums(completion: ((error: NSError!) -> Void)?) {

        super.getFBDataJSON(kGraphPathPIMagazineAlbumsString, params: kParamsOnlyAccessToken,
            onSuccess: { (jsonData) -> Void in
                let albumsList = jsonData["data"]
                let firstAlbumID = albumsList[0]["id"].stringValue
                let secAlbumID = albumsList[1]["id"].stringValue
                let thirdAlbumID = albumsList[2]["id"].stringValue
                let params = [
                    "access_token": kAppAccessToken,
                    "fields" : "photos.limit(20){picture}",
                ]
                self.getDataFromFBAlbum(firstAlbumID, params: params, completion: { () -> Void in
                    self.getDataFromFBAlbum(secAlbumID, params: params, completion: { () -> Void in
                        self.getDataFromFBAlbum(thirdAlbumID, params: params, completion: { () -> Void in
                            self.delegate?.didFinishGettingFacebookPhotos(self.FBPhotoObjectsArray)
                        })
                    })
                })
            },
            onError: { (error) -> Void in
                if let completion = completion {
                    completion(error: error)
                }
        })
    }
    
    private func getDataFromFBAlbum(albumID: String, params: [String : String], completion: (() -> Void)?) {
        FBSDKGraphRequest(graphPath: albumID, parameters: params).startWithCompletionHandler { (connection, albumPhotos, error) -> Void in
            //            println(albumPhotos)
            let albumPhotosJSON = JSON(albumPhotos)
            let photos = albumPhotosJSON["photos"]
            let photosArray = photos["data"].arrayValue
            //            println(photosArray.description)
            for object:JSON in photosArray {
                let newPicObject = FBPhotoObject(id: object["id"].stringValue, albumPicURLString: object["picture"].stringValue)
                self.FBPhotoObjectsArray.append(newPicObject)
            }
            if let completion = completion {
                completion()
            }
        }
    }
    
    func getNormalSizePhotoURLStringFrom(id: String, completion: ((normImgUrlString: String) -> Void)?) -> Void{
        let graphPathString = "\(id)/picture?type=normal&redirect=false"
        super.getFBDataJSON(graphPathString, params: kParamsOnlyAccessToken,
            onSuccess: { (jsonData) -> Void in
              let object = jsonData["data"]
              let url = object["url"]
              if let completion = completion {
                completion(normImgUrlString: url.stringValue)
              }
        },
            onError: { (error: NSError!) -> Void in
                print(error.description)
        })
    }
    
    func getNormalSizePhotoURLStringForCommunicationsFrom(id: String, completion: ((normImgUrlString: String) -> Void)?) -> Void{
        let params = [
            "access_token": kAppAccessToken,
            "fields" : "full_picture"
        ]
        let graphPathString = "\(id)"
        super.getFBDataJSON(graphPathString, params: params,
            onSuccess: { (jsonData) -> Void in
                let url = jsonData["full_picture"]
                if let completion = completion {
                    completion(normImgUrlString: url.stringValue)
                }
            },
            onError: { (error: NSError!) -> Void in
                print(error.description)
        })
    }
    
    
}