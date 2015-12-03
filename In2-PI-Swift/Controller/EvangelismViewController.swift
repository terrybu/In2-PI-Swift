//
//  EvangelismViewController.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 8/29/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import UIKit

private let kOriginalContentViewHeight: CGFloat = 600

class EvangelismViewController: ParentViewController {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var expandableAboutView: ExpandableAboutView!
    //Constraints
    @IBOutlet weak var constraintHeightExpandableView: NSLayoutConstraint!
    @IBOutlet weak var constraintContentViewHeight: NSLayoutConstraint!
    var expandedAboutViewHeight:CGFloat = 0

    override func viewDidLoad() {
        setUpStandardUIForViewControllers()
        setUpExpandableAboutView()
    }
    
    private func setUpExpandableAboutView() {
        expandedAboutViewHeight = kOriginalAboutViewHeight + expandableAboutView.textView.frame.size.height
        expandableAboutView.clipsToBounds = true
        expandableAboutView.delegate = ExpandableAboutViewHandler(viewControllerView: view, expandableView: expandableAboutView, constraintExpandableViewHeight: constraintHeightExpandableView, constraintContentViewHeight: constraintContentViewHeight, originalAboutViewHeight: kOriginalAboutViewHeight, expandedAboutViewHeight: expandedAboutViewHeight, originalContentViewHeight: kOriginalContentViewHeight)
    }
    
}