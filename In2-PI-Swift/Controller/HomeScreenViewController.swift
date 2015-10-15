//
//  HomeScreenViewController.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 8/29/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import UIKit
import MBProgressHUD

private let purpleBarSelectorBelowLabelHeightPadding:CGFloat = 4

class HomeScreenViewController: ParentViewController, FacebookFeedQueryDelegate {
    
    // MARK: Properties
    var black: UIView!
    var purpleBarSelector: UIImageView!
    var firstObjectID: String!
    @IBOutlet weak var myFeedButton: UIButton!
    @IBOutlet weak var piFeedButton: UIButton!

    @IBOutlet weak var newsArticleView: NewsArticleView!
    var imageBlackOverlay: UIView?
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //Do any additional setup after loading the view, typically from a nib.
        //this is BEFORE autolayout applied
        
        setUpUniqueUIForHomeVC()
        
        blackOverlayUntilFBDataFinishedLoading()
        FacebookFeedQuery.sharedInstance.delegate = self
        FacebookFeedQuery.sharedInstance.getFeedFromPIMagazine { (error) -> Void in
            if error != nil {
                print(error.description)
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            }
        }
        print("view did load + \(newsArticleView.backgroundImageView.frame.size)")
    }
    
    private func setUpUniqueUIForHomeVC() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navigation_bar"), forBarMetrics: UIBarMetrics.Default)
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        let hamburger = UIBarButtonItem(image: UIImage(named: "hamburger"), style: UIBarButtonItemStyle.Done, target: self, action: Selector("hamburgerPressed:"))
        navigationItem.leftBarButtonItem = hamburger
    }
    
    private func blackOverlayUntilFBDataFinishedLoading() {
        black = UIView(frame: view.frame)
        black.backgroundColor = UIColor.blackColor()
        view.addSubview(black)
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.labelText = "Loading..."
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if (purpleBarSelector == nil) {
            addPurpleSelectorBar()
            purpleBarSelector.hidden = true
        }
    }
    
    //MARK: Custom Methods
    private func addPurpleSelectorBar() {
        purpleBarSelector = UIImageView(image: UIImage(named: "selector_MyPI"))
        purpleBarSelector.frame = CGRect(x: 0, y: myFeedButton.frame.height + purpleBarSelectorBelowLabelHeightPadding, width: self.view.frame.width/2, height: 4)
        view.addSubview(purpleBarSelector)
    }
    
    func tappedLabel(sender: UIGestureRecognizer) {
        print(firstObjectID)
        //postURL has to nick out the second part of the _ string from firstObjectID
        let postURLParam = firstObjectID.componentsSeparatedByString("_").last
        let postURL = "https://www.facebook.com/IN2PI/posts/\(postURLParam!)"
        let wkWebView = UIWebView(frame: self.view.frame)
        wkWebView.loadRequest(NSURLRequest(URL: NSURL(string: postURL)!))
        let emptyVC = UIViewController()
        emptyVC.view = wkWebView
        navigationController?.pushViewController(emptyVC, animated: true)
    }
    
    //MARK: FacebookFeedQueryDelegate 
    func didFinishGettingFacebookFeedData(fbFeedObjectArray: [FBFeedArticle]) {
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("tappedLabel:"))
        newsArticleView.userInteractionEnabled = true
        newsArticleView.addGestureRecognizer(tapGesture)
        
        let firstObject = fbFeedObjectArray[0]
        FacebookFeedQuery.sharedInstance.parseMessageForLabels(firstObject, articleCategoryLabel: newsArticleView.categoryLabel, articleTitleLabel: newsArticleView.titleLabel, articleDateLabel: newsArticleView.dateLabel)
        firstObjectID = firstObject.id
        if firstObject.type == "photo" {
            FacebookPhotoQuery.sharedInstance.getNormalSizePhotoURLStringForCommunicationsFrom(firstObject.id, completion: { (normImgUrlString) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.newsArticleView.backgroundImageView.setImageWithURL(NSURL(string: normImgUrlString))
                })
            })
        }
        self.black.removeFromSuperview()
        self.purpleBarSelector.hidden = false
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func myFeedButtonPressed(sender: UIButton) {
        sender.setTitleColor(UIColor.In2DeepPurple(), forState: UIControlState.Normal)
        piFeedButton.setTitleColor(UIColor(rgba: "#bbbcbc"), forState: UIControlState.Normal)
        purpleBarSelector.frame = CGRect(x: 0, y: myFeedButton.frame.height + purpleBarSelectorBelowLabelHeightPadding, width:view.frame.size.width/2, height: 4)
    }
    
    @IBAction func piFeedButtonPressed(sender: UIButton) {
        sender.setTitleColor(UIColor.In2DeepPurple(), forState: UIControlState.Normal)
        myFeedButton.setTitleColor(UIColor(rgba: "#bbbcbc"), forState: UIControlState.Normal)
        purpleBarSelector.frame = CGRect(x: view.frame.width/2, y: myFeedButton.frame.height + purpleBarSelectorBelowLabelHeightPadding, width:view.frame.size.width/2, height: 4)
    }

    
}
