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

private let cellReuseIdentifier = "GalleryCell"

class GalleryViewController: ParentViewController, FacebookManagerDelegate, UICollectionViewDataSource, UICollectionViewDelegate{
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var topImageView: UIImageView!
    var photoObjectsArray: [FBPhotoObject]?
    
    override func viewDidLoad() {
        setUpStandardUIForViewControllers()
        FacebookManager.sharedInstance.delegate = self
        FacebookManager.sharedInstance.getPhotosFromPIMagazineFBAlbum()
    }
    
    //MARK: FacebookManagerDelegate methods
    func didFinishGettingFacebookPhotos(fbPhotoObjectArray: [FBPhotoObject]) {
        self.photoObjectsArray = fbPhotoObjectArray
        let firstObject = photoObjectsArray![0]
        setMostRecentImgInNormalSizeToTopImageView(firstObject)
        self.collectionView.reloadData()
    }
    
    private func setMostRecentImgInNormalSizeToTopImageView(fbObject: FBPhotoObject) {
        //FacebookManager needs to call a new Graph API request with the object
        FacebookManager.sharedInstance.getNormalSizePhotoURLStringFrom(fbObject
            , completion: { (normImgUrlString) -> Void in
                self.topImageView.setImageWithURL(NSURL(string: normImgUrlString ))
        })
    }
    
    //MARK UICollectionView delegate methods
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if let photoObjectsArray = self.photoObjectsArray {
            return 1
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let photoObjectsArray = self.photoObjectsArray {
            return photoObjectsArray.count
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuseIdentifier, forIndexPath: indexPath) as! GalleryCell
        
        // Configure the cell
        let photoObject = photoObjectsArray![indexPath.row]
        cell.imageView!.setImageWithURL(NSURL(string: photoObject.albumSizePicURLString ))

        return cell
    }
    
    
}