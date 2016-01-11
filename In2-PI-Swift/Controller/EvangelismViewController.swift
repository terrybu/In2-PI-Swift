//
//  EvangelismViewController.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 8/29/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import UIKit

class EvangelismViewController: ParentViewController {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var expandableAboutView: ExpandableAboutView!
    @IBOutlet weak var constraintHeightExpandableView: NSLayoutConstraint!
    @IBOutlet weak var constraintContentViewHeight: NSLayoutConstraint!
    @IBOutlet var evangelismNewsWidgetView: EvangelismNewsWidgetView!
    var expandedAboutViewHeight:CGFloat = 0
    private let kOriginalContentViewHeight: CGFloat = 600
    var evangelismFeedObject: FBFeedPost?
    
    override func viewDidLoad() {
        setUpStandardUIForViewControllers()
        setUpExpandableAboutView()
        
        for feedObject in FacebookFeedQuery.sharedInstance.FBFeedObjectsArray {
            if feedObject.parsedCategory == "PI선교" {
                evangelismFeedObject = feedObject
                evangelismNewsWidgetView.title = feedObject.parsedTitle
                evangelismNewsWidgetView.dateLabel.text = feedObject.parsedDate
                evangelismNewsWidgetView.viewMoreButton.addTarget(self, action: "viewMoreButtonWasPressedForEvangelismNews", forControlEvents: UIControlEvents.TouchUpInside)
                break
            }
        }
        guard let evangelismFeedObject = evangelismFeedObject else {
            evangelismNewsWidgetView.title = "최신 선교 뉴스가 없거나 Facebook 데이터 다운로드가 실패했습니다."
            return
        }
    }
    
    @objc
    private func viewMoreButtonWasPressedForEvangelismNews() {
        if let feedObject = evangelismFeedObject {
            FacebookFeedQuery.sharedInstance.displayFacebookPostObjectInWebView(feedObject, view: self.view, navigationController: navigationController)
        }
    }
    
    private func setUpExpandableAboutView() {
        expandedAboutViewHeight = kOriginalAboutViewHeight + expandableAboutView.textView.frame.size.height + 30 
        expandableAboutView.clipsToBounds = true
        expandableAboutView.delegate = ExpandableAboutViewHandler(viewControllerView: view, expandableView: expandableAboutView, constraintExpandableViewHeight: constraintHeightExpandableView, constraintContentViewHeight: constraintContentViewHeight, originalAboutViewHeight: kOriginalAboutViewHeight, expandedAboutViewHeight: expandedAboutViewHeight, originalContentViewHeight: kOriginalContentViewHeight)
    }
    
}