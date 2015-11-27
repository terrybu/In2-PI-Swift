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
    var feedObjectsArray: [FBFeedPost]?
    
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
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.constraintHeightExpandableView.constant = self.expandedAboutViewHeight
                self.view.layoutIfNeeded()
                
                }) { (Bool completed) -> Void in
                    self.expandableAboutView.expanded = true
            }
        }
        else {
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
        
        cell.tag = indexPath.row
        configureCell(cell, indexPath: indexPath)
        
        let tap = UITapGestureRecognizer(target: self, action: "tappedCell:")
        cell.userInteractionEnabled = true
        cell.addGestureRecognizer(tap)
        
        return cell
    }
    
    func configureCell(cell: CommunicationsTableViewCell, indexPath: NSIndexPath) {
        let feedObject = feedObjectsArray![indexPath.row]
        cell.categoryLabel.text = feedObject.parsedCategory
        cell.titleLabel.text = feedObject.parsedTitle
        cell.dateLabel.text = feedObject.parsedDate

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
//                        print("afnetworking image download finished for indexpath: \(indexPath.row)")
                        activityIndicator.stopAnimating()

                        if cell.tag == indexPath.row {
                            self.cache.setObject(responseObject, forKey: "\(indexPath.row)")
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.tableView .reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
                            })
                        }
                    }, failure: {
                        (operation, error) -> Void in
                            print(error)
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                activityIndicator.stopAnimating()
                            })
                        }
                    )
                })
            }
        } else {
            cell.backgroundImageView.image = UIImage(named:"sampleGray")
        }
    }
    
    func tappedCell(sender: UIGestureRecognizer) {
        //postURL has to nick out the second part of the _ string from firstObjectID
        let i = sender.view?.tag
        let feedObject = feedObjectsArray![i!]
        let postURLParam = feedObject.id.componentsSeparatedByString("_").last
        let postURL = "https://www.facebook.com/IN2PI/posts/\(postURLParam!)"
        let wkWebView = UIWebView(frame: self.view.frame)
        wkWebView.loadRequest(NSURLRequest(URL: NSURL(string: postURL)!))
        let emptyVC = UIViewController()
        emptyVC.view = wkWebView
        navigationController?.pushViewController(emptyVC, animated: true)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let feedArticle = feedObjectsArray![indexPath.row] as FBFeedPost
        print(feedArticle)
    }
    
}