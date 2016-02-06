//
//  NurtureViewController.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 8/29/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import UIKit
import SafariServices

class NurtureViewController: ParentViewController, SFSafariViewControllerDelegate, UIGestureRecognizerDelegate{

    private let kOriginalContentViewHeight: CGFloat = 454
    var expandedAboutViewHeight:CGFloat = 0
    var nurtureFeedObject: FBFeedPost? 
    @IBOutlet var contentView: UIView!
    @IBOutlet var expandableAboutView: ExpandableAboutView!
    @IBOutlet weak var constraintHeightExpandableView: NSLayoutConstraint!
    @IBOutlet weak var constraintContentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var leftNurtureApplyWidget: ApplyWidgetView!
    @IBOutlet weak var rightHolyStarApplyWidget: ApplyWidgetView!
    @IBOutlet weak var nurtureNewsWidget: BoroSpecificNewsWidgetView!


    override func viewDidLoad() {
        setUpStandardUIForViewControllers()
        setUpExpandableAboutView()
        leftNurtureApplyWidget.applyButtonPressedHandler = {(sender) -> Void in
            self.presentSFSafariVCIfAvailable(NSURL(string: kApplyNurtureTeamGoogleDocURL)!)
        }
        rightHolyStarApplyWidget.applyButtonPressedHandler = {(sender) -> Void in
            self.openHolyStarIntroViewController()
        }
        for feedObject in FacebookFeedQuery.sharedInstance.FBFeedObjectsArray {
            if feedObject.parsedCategory == "PI양육" {
                nurtureFeedObject = feedObject
                nurtureNewsWidget.title = feedObject.parsedTitle
                nurtureNewsWidget.dateLabel.text = feedObject.parsedDate
                nurtureNewsWidget.viewMoreButton.addTarget(self, action: "viewMoreButtonWasPressedForNurtureNews", forControlEvents: UIControlEvents.TouchUpInside)
                break
            }
        }
        guard let nurtureFeedObject = nurtureFeedObject else {
            nurtureNewsWidget.title = "최근 양육뉴스가 존재하지 않습니다."
            nurtureNewsWidget.dateLabel.text = nil
            return
        }
    }
    
    @objc
    private func viewMoreButtonWasPressedForNurtureNews() {
        if let feedObject = nurtureFeedObject {
            FacebookFeedQuery.sharedInstance.displayFacebookPostObjectInWebView(feedObject, view: self.view, navigationController: navigationController)
        }
    }
    
    private func presentSFSafariVCIfAvailable(url: NSURL) {
        let sfVC = SFSafariViewController(URL: url, entersReaderIfAvailable: true)
        sfVC.delegate = self
        self.presentViewController(sfVC, animated: true, completion: nil)
        //in case anybody prefers right to left push viewcontroller animation transition (below)
        //navigationController?.pushViewController(sfVC, animated: true)
    }
    
    private func setUpExpandableAboutView() {
        expandedAboutViewHeight = kOriginalAboutViewHeight + expandableAboutView.textView.frame.size.height + 30
        expandableAboutView.clipsToBounds = true
        expandableAboutView.delegate = ExpandableAboutViewHandler(viewControllerView: view, expandableView: expandableAboutView, constraintExpandableViewHeight: constraintHeightExpandableView, constraintContentViewHeight: constraintContentViewHeight, originalAboutViewHeight: kOriginalAboutViewHeight, expandedAboutViewHeight: expandedAboutViewHeight, originalContentViewHeight: kOriginalContentViewHeight)
        expandableAboutView.userInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: "tappedEntireAboutView")
        expandableAboutView.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
    }
    
    func tappedEntireAboutView() {
        expandableAboutView.delegate?.didPressExpandButton()
    }
    
    private func openHolyStarIntroViewController() {
        let holyStarVC = HolyStarIntroViewController(nibName: "HolyStarIntroViewController", bundle: nil)
        holyStarVC.title = "홀리스타"
        self.navigationController?.pushViewController(holyStarVC, animated: true)
    }

    

}
