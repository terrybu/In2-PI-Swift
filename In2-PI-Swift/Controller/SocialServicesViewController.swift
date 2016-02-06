//
//  SocialServicesViewController.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 8/29/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import UIKit

class SocialServicesViewController: ParentViewController, UITableViewDelegate, UITableViewDataSource{
   
    @IBOutlet var contentView: UIView!
    @IBOutlet var expandableAboutView: ExpandableAboutView!
    @IBOutlet weak var constraintHeightExpandableView: NSLayoutConstraint!
    @IBOutlet weak var constraintContentViewHeight: NSLayoutConstraint!
    private var expandedAboutViewHeight: CGFloat = 0
    private let kOriginalContentViewHeight: CGFloat = 605

    override func viewDidLoad() {
        setUpStandardUIForViewControllers()
        setUpExpandableAboutView(kOriginalAboutViewHeight, expandableAboutView: expandableAboutView, heightBuffer: 50, view: view, constraintHeightExpandableView: constraintHeightExpandableView, constraintContentViewHeight: constraintContentViewHeight, originalContentviewHeight: kOriginalContentViewHeight)
    }
    
    
    //MARK: UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SocialServicesCell", forIndexPath: indexPath) as UITableViewCell
        configureCell(cell, forRowAtIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, forRowAtIndexPath: NSIndexPath) {
        cell.textLabel!.text = "긍휼부 이벤트 0\(forRowAtIndexPath.row)"
    }
    
    
    
}