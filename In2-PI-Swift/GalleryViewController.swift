//
//  GalleryViewController.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 8/29/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import SwiftyJSON
import AFNetworking

class GalleryViewController: ParentViewController {
    
    var photosArray : [JSON]!
    var initialY : CGFloat!
    
    override func viewDidLoad() {
        setUpStandardUIForViewControllers()
        
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
                    println(albumPhotos)
                    let albumPhotosJSON = JSON(albumPhotos)
                    let photos = albumPhotosJSON["photos"]
                    self.photosArray = photos["data"].arrayValue
                    self.initialY = 50.0
                    for photoObject in self.photosArray {
                        let photoURLString = photoObject["picture"].string
                        dispatch_async(dispatch_get_main_queue(),{
                            if let initial = self.initialY {
                                var imageView = UIImageView(frame: CGRectMake(50.0,self.initialY,200.0,200.0))
                                imageView.setImageWithURL(NSURL(string: photoURLString!))
                                self.view.addSubview(imageView)
                                self.initialY = self.initialY + 200
                            }
                        })
                    }
                }
            }
            else {
                println(error)
            }
        }

    }
    
}