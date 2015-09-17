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

class HomeScreenViewController: UIViewController, FacebookFeedQueryDelegate {
    
    // MARK: Properties
    var black: UIView!
    var purpleBarSelector: UIImageView!
    var firstObjectID: String!
    @IBOutlet weak var myPIButton: UIButton!
    @IBOutlet weak var PICommunityButton: UIButton!
    @IBOutlet weak var hamburgerButton: UIBarButtonItem!
    @IBOutlet weak var articleCategoryLabel:PaddedLabel!
    @IBOutlet weak var articleTitleLabel:UILabel!
    @IBOutlet weak var articleDateLabel: UILabel!
    @IBOutlet weak var QTTitleLabel: UILabel!
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        articleCategoryLabel.layer.borderWidth = 1
        articleCategoryLabel.layer.borderColor = UIColor.whiteColor().CGColor
        articleCategoryLabel.edgeInsets = UIEdgeInsetsMake(0, 10, 0, 10)
        blackOverlayUntilFBDataFinishedLoading()
        FacebookFeedQuery.sharedInstance.delegate = self
        FacebookFeedQuery.sharedInstance.getFeedFromPIMagazine { (error) -> Void in
            if error != nil {
                print(error.description)
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            }
        }
    }
    
    private func blackOverlayUntilFBDataFinishedLoading() {
        black = UIView(frame: view.frame)
        black.backgroundColor = UIColor.blackColor()
        view.addSubview(black)
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.labelText = "Loading..."
    }
    
    override func viewDidAppear(animated: Bool) {
        if (purpleBarSelector == nil) {
            addPurpleSelectorBar()
            purpleBarSelector.hidden = true
        }
        if revealViewController() != nil {
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
            view.addGestureRecognizer(revealViewController().tapGestureRecognizer())
            revealViewController().rearViewRevealWidth = view.frame.size.width
        }
    }
    
    //MARK: Custom Methods
    private func addPurpleSelectorBar() {
        purpleBarSelector = UIImageView(image: UIImage(named: "selector_MyPI"))
        purpleBarSelector.frame = CGRect(x: view.frame.width/4-18, y: myPIButton.frame.height + purpleBarSelectorBelowLabelHeightPadding, width:myPIButton.titleLabel!.frame.size.width, height: 4)
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
    func didFinishGettingFacebookFeedData(fbFeedObjectArray: [FBFeedObject]) {
        let firstObject = fbFeedObjectArray[0]
        FacebookFeedQuery.sharedInstance.parseMessageForLabels(firstObject, articleCategoryLabel: articleCategoryLabel, articleTitleLabel: articleTitleLabel, articleDateLabel: articleDateLabel)
        firstObjectID = firstObject.id
        
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("tappedLabel:"))
        articleTitleLabel.userInteractionEnabled = true
        articleTitleLabel.addGestureRecognizer(tapGesture)
        
        black.removeFromSuperview()
        purpleBarSelector.hidden = false
        MBProgressHUD.hideAllHUDsForView(view, animated: true)
    }

        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: IBActions
    @IBAction func hamburgerPressed(sender: UIBarButtonItem) {
        revealViewController().revealToggle(sender)
        //        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //        appDelegate.statusBarBackgroundView?.hidden = true
    }
    
    @IBAction func myPIButtonPressed(sender: UIButton) {
        sender.setTitleColor(UIColor.In2DeepPurple(), forState: UIControlState.Normal)
        PICommunityButton.setTitleColor(UIColor(rgba: "#bbbcbc"), forState: UIControlState.Normal)
        purpleBarSelector.frame = CGRect(x: view.frame.width/4-18, y: myPIButton.frame.height + purpleBarSelectorBelowLabelHeightPadding, width:myPIButton.titleLabel!.frame.size.width, height: 4)
    }
    
    @IBAction func PICommunityButtonPressed(sender: UIButton) {
        sender.setTitleColor(UIColor.In2DeepPurple(), forState: UIControlState.Normal)
        myPIButton.setTitleColor(UIColor(rgba: "#bbbcbc"), forState: UIControlState.Normal)
        purpleBarSelector.frame = CGRect(x: view.frame.width/2+48, y: myPIButton.frame.height + purpleBarSelectorBelowLabelHeightPadding, width:PICommunityButton.titleLabel!.frame.size.width, height: 4)
    }

    
}
