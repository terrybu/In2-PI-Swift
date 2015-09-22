//
//  CommunicationsViewController.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 8/29/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import UIKit
import AFNetworking

private let kOriginalAboutViewHeight: CGFloat = 32.0

class CommunicationsViewController: ParentViewController, UITableViewDelegate, UITableViewDataSource, ExpandableAboutViewDelegate{
    
    @IBOutlet var tableView: UITableView!
    var feedObjectsArray: [FBFeedArticle]?
    var contentViewHeightBasedOnTableView: CGFloat = 0
    
    //For expandable view
    @IBOutlet var expandableAboutView: ExpandableAboutView!
    @IBOutlet weak var constraintHeightExpandableView: NSLayoutConstraint!
    
    var cache: NSCache = NSCache()
    var operationManager: AFHTTPRequestOperationManager?
    var expandedAboutViewHeight:CGFloat = 0

    override func viewDidLoad() {
        setUpStandardUIForViewControllers()
        tableView.registerNib(UINib(nibName: "CommunicationsTableViewCell", bundle: nil), forCellReuseIdentifier: "CommunicationsCell")
        self.feedObjectsArray = FacebookFeedQuery.sharedInstance.FBFeedObjectsArray
        
        expandedAboutViewHeight = expandableAboutView.aboutLabel.frame.size.height + expandableAboutView.textView.frame.size.height + 10
        setUpExpandableAboutView()
        
        operationManager = AFHTTPRequestOperationManager()
        operationManager!.responseSerializer = AFImageResponseSerializer()
    }
    
    //MARK: ExpandableAboutViewDelegate
    private func setUpExpandableAboutView() {
        expandableAboutView.clipsToBounds = true
        expandableAboutView.delegate = self
    }
    
    func didPressExpandButton() {
        if !expandableAboutView.expanded {
            print("did press expand button when it wasn't expanded")
            
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.constraintHeightExpandableView.constant = self.expandedAboutViewHeight
                self.view.layoutIfNeeded()
                
                }) { (Bool completed) -> Void in
                    self.expandableAboutView.expanded = true
            }
        }
        else {
            print("did press expand button when it WAS expanded")
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.constraintHeightExpandableView.constant = kOriginalAboutViewHeight
                self.view.layoutIfNeeded()
                
                }) { (Bool completed) -> Void in
                    self.expandableAboutView.expanded = false
            }
        }
        
    }
    
    
    //MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let feedObjectsArray = self.feedObjectsArray else {
            return 0
        }
        return feedObjectsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CommunicationsCell", forIndexPath: indexPath) as! CommunicationsTableViewCell
        
        print("cell For row is excuting for indexpath: \(indexPath.row)")

        configureCell(cell, indexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: CommunicationsTableViewCell, indexPath: NSIndexPath) {
        let feedObject = feedObjectsArray![indexPath.row]
        FacebookFeedQuery.sharedInstance.parseMessageForLabels(feedObject, articleCategoryLabel: cell.articleCategoryLabel, articleTitleLabel: cell.articleTitleLabel, articleDateLabel: cell.articleDateLabel)
        if feedObject.type == "photo" {
            if cache.objectForKey("\(indexPath.row)") != nil{
                let img = cache.objectForKey("\(indexPath.row)") as! UIImage
                cell.backgroundImageView.image = img
            } else {
                cell.backgroundImageView.image = nil
                let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
                activityIndicator.center = view.center
                view.addSubview(activityIndicator)
                activityIndicator.startAnimating()
                FacebookPhotoQuery.sharedInstance.getNormalSizePhotoURLStringForCommunicationsFrom(feedObject.id, completion: { (normImgUrlString) -> Void in
                    self.operationManager?.GET(normImgUrlString, parameters: nil, success: { (operation, responseObject) -> Void in
                            //success
                            print("afnetworking image download finished for indexpath: \(indexPath.row)")

                            self.cache.setObject(responseObject, forKey: "\(indexPath.row)")
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                activityIndicator.stopAnimating()
                                self.tableView .reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
                            })
                    }, failure: { (operation, error) -> Void in
                            print(error)
                        activityIndicator.stopAnimating()
                    })

                })
            }
        } else {
            cell.backgroundImageView.image = UIImage(named:"sampleGray")
        }
    }
    
    
}