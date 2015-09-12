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
        if revealViewController() != nil {
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
            view.addGestureRecognizer(revealViewController().tapGestureRecognizer())
            revealViewController().rearViewRevealWidth = view.frame.size.width
        }
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
        parseMessageForLabels(firstObject)
        firstObjectID = firstObject.id
        
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("tappedLabel:"))
        articleTitleLabel.userInteractionEnabled = true
        articleTitleLabel.addGestureRecognizer(tapGesture)
        
        black.removeFromSuperview()
        purpleBarSelector.hidden = false
        MBProgressHUD.hideAllHUDsForView(view, animated: true)
    }
    
    func parseMessageForLabels(firstObject: FBFeedObject) {
        var categoryStr = ""
        var firstTitleStr: String?
        let msg = firstObject.message
        if (!msg.isEmpty) {
            if (msg[0] == "[") {
                print("found open bracket")
                for (var i=1; i < msg.characters.count; i++) {
                    categoryStr += msg[i]
                    let j = i + 1
                    if (msg[j] == "]" || categoryStr.characters.count >= 100) {
                        firstTitleStr = parseFirstLineTitleString(msg[j+1..<msg.characters.count])
                        break
                    }
                }
            }
            articleCategoryLabel.text = categoryStr
            if let _ = firstTitleStr {
                articleTitleLabel.text = firstTitleStr
            }
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
            let date = dateFormatter.dateFromString(firstObject.created_time)
            if let date = date {
                dateFormatter.dateFormat = "yyyy-MM-dd EEE hh:mm a"
                articleDateLabel.text = dateFormatter.stringFromDate(date)
            }
        }
    }
    
    func parseFirstLineTitleString(msg: String) -> String {
        //Given a string that starts with an empty space and then a sententece followed by \n or just \n Title \n ... return thet tile.
        // " blahblahblah \n" --> should return blahblahblah
        // " \n blahblahblah \n" should also return blahblahblah
        var result = ""
        let startingStr = msg[1..<msg.characters.count]
        if (startingStr[0] == "\n") {
            //if it finds \n immediately (which means author inserted a new line between category and title, we just jump and start from the next line
            var i = 1;
            while (startingStr[i] != "\n") {
                result += startingStr[i]
                i++;
            }
        }
        else {
            //otherwise, we go right for the first line
            var i = 0;
            while (startingStr[i] != "\n") {
                result += startingStr[i]
                i++;
            }
        }
        return result
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
