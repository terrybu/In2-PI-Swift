//
//  SocialServicesViewController.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 8/29/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import UIKit

private let kOriginalAboutViewHeight: CGFloat = 32.0
private let kExpandedAboutViewHeight: CGFloat = 300.0
private let kOriginalContentViewHeight: CGFloat = 605

class SocialServicesViewController: ParentViewController, UITableViewDelegate, UITableViewDataSource{
   
    @IBOutlet var contentView: UIView!
    @IBOutlet var expandableAboutView: ExpandableAboutView!
    //Constraints
    @IBOutlet weak var constraintHeightExpandableView: NSLayoutConstraint!
    @IBOutlet weak var constraintContentViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        setUpStandardUIForViewControllers()
        setUpExpandableAboutView()
    }
    
    private func setUpExpandableAboutView() {
        expandableAboutView.clipsToBounds = true
        expandableAboutView.delegate = ExpandableAboutViewHandler(viewControllerView: view, expandableView: expandableAboutView, constraintExpandableViewHeight: constraintHeightExpandableView, constraintContentViewHeight: constraintContentViewHeight, originalAboutViewHeight: kOriginalAboutViewHeight, expandedAboutViewHeight: kExpandedAboutViewHeight, originalContentViewHeight: kOriginalContentViewHeight)
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