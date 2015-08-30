//
//  GalleryViewController.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 8/29/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import UIKit
import SwiftyJSON
import AFNetworking

class GalleryViewController: ParentViewController, FacebookManagerDelegate {
    
    override func viewDidLoad() {
        setUpStandardUIForViewControllers()
        let sharedFBManager = FacebookManager.sharedInstance
        sharedFBManager.delegate = self
        sharedFBManager.getPhotosFromFacebookAlbum()
    }
    
    func didFinishGettingFacebookPhotos(jsonArray: [JSON]) {
        var initialY: CGFloat = 50.0
        for photoObject in jsonArray {
            let photoURLString = photoObject["picture"].string
            dispatch_async(dispatch_get_main_queue(),{
                var imageView = UIImageView(frame: CGRectMake(50.0, initialY,200.0,200.0))
                imageView.setImageWithURL(NSURL(string: photoURLString!))
                self.view.addSubview(imageView)
                initialY = initialY + 200
            })
        }
    }
    
}