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
    var photoObjectsArray: [JSON]?
    
    override func viewDidLoad() {
        setUpStandardUIForViewControllers()
        let sharedFBManager = FacebookManager.sharedInstance
        sharedFBManager.delegate = self
        sharedFBManager.getPhotosFromFacebookAlbum()
    }
    
    //MARK: FacebookManagerDelegate methods
    func didFinishGettingFacebookPhotos(jsonArray: [JSON]) {
        self.photoObjectsArray = jsonArray
        let firstObjectURL = photoObjectsArray![0]["picture"].string!
        setFirstImageToTopImageView(firstObjectURL)
        self.collectionView.reloadData()
    }
    
    private func setFirstImageToTopImageView(imageURLString: String) {
        self.topImageView.setImageWithURL(NSURL(string: imageURLString))
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
        let photoDict = photoObjectsArray![indexPath.row]
        cell.imageView!.setImageWithURL(NSURL(string: photoDict["picture"].string!))

        return cell
    }
    
    
}