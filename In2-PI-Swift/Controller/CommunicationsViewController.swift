//
//  CommunicationsViewController.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 8/29/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import UIKit

private let kOriginalAboutViewHeight: CGFloat = 32.0
private let kExpandedAboutViewHeight: CGFloat = 300.0

class CommunicationsViewController: ParentViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    var feedObjectsArray: [FBFeedObject]?
    var contentViewHeightBasedOnTableView: CGFloat = 0
    
    //For expandable view
    @IBOutlet var contentView: UIView!
    @IBOutlet var expandableAboutView: ExpandableAboutView!
    @IBOutlet weak var constraintHeightExpandableView: NSLayoutConstraint!
    @IBOutlet weak var constraintContentViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        setUpStandardUIForViewControllers()
        tableView.registerNib(UINib(nibName: "CommunicationsTableViewCell", bundle: nil), forCellReuseIdentifier: "CommunicationsCell")
        self.feedObjectsArray = FacebookFeedQuery.sharedInstance.FBFeedObjectsArray
        if let feedObjectsArray = feedObjectsArray {
            contentViewHeightBasedOnTableView = CGFloat(feedObjectsArray.count * 200)
            constraintContentViewHeight.constant = contentViewHeightBasedOnTableView
            view.layoutIfNeeded()
//            contentView.frame.size = CGSize(width: view.frame.size.width, height: contentViewHeightBasedOnTableView)
        }
        setUpExpandableAboutView()

    }
    
    private func setUpExpandableAboutView() {
        expandableAboutView.clipsToBounds = true
        expandableAboutView.delegate = ExpandableAboutViewHandler(viewControllerView: view, expandableView: expandableAboutView, constraintExpandableViewHeight: constraintHeightExpandableView, constraintContentViewHeight: constraintContentViewHeight, originalAboutViewHeight: kOriginalAboutViewHeight, expandedAboutViewHeight: kExpandedAboutViewHeight, originalContentViewHeight: contentViewHeightBasedOnTableView)
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
        configureCell(cell, forRowAtIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: CommunicationsTableViewCell, forRowAtIndexPath: NSIndexPath) {
        let feedObject = feedObjectsArray![forRowAtIndexPath.row]
        FacebookFeedQuery.sharedInstance.parseMessageForLabels(feedObject, articleCategoryLabel: cell.articleCategoryLabel, articleTitleLabel: cell.articleTitleLabel, articleDateLabel: cell.articleDateLabel)
    }
    
    
}