//
//  HomeScreenViewController.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 8/29/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import UIKit

private let purpleBarSelectorBelowLabelHeightPadding:CGFloat = 4

class HomeScreenViewController: UIViewController, FacebookFeedQueryDelegate {
    
    var purpleBarSelector: UIImageView!
    var firstObjectID: String!
    @IBOutlet weak var myPIButton: UIButton!
    @IBOutlet weak var PICommunityButton: UIButton!
    @IBOutlet weak var hamburgerButton: UIBarButtonItem!
    @IBOutlet weak var articleCategoryLabel:UILabel!
    @IBOutlet weak var articleTitleLabel:UILabel!
    @IBOutlet weak var articleDateLabel: UILabel!
    @IBOutlet weak var QTTitleLabel: UILabel!
    
    @IBAction func hamburgerPressed(sender: UIBarButtonItem) {
        self.revealViewController().revealToggle(sender)
        //        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //        appDelegate.statusBarBackgroundView?.hidden = true
    }
    
    @IBAction func myPIButtonPressed(sender: UIButton) {
        sender.setTitleColor(UIColor(rgba: "#9f5cc0"), forState: UIControlState.Normal)
        PICommunityButton.setTitleColor(UIColor(rgba: "#bbbcbc"), forState: UIControlState.Normal)
        purpleBarSelector.frame = CGRect(x: view.frame.width/4-18, y: myPIButton.frame.height + purpleBarSelectorBelowLabelHeightPadding, width:myPIButton.titleLabel!.frame.size.width, height: 4)
    }
    
    @IBAction func PICommunityButtonPressed(sender: UIButton) {
        sender.setTitleColor(UIColor(rgba: "#9f5cc0"), forState: UIControlState.Normal)
        myPIButton.setTitleColor(UIColor(rgba: "#bbbcbc"), forState: UIControlState.Normal)
        purpleBarSelector.frame = CGRect(x: view.frame.width/2+48, y: myPIButton.frame.height + purpleBarSelectorBelowLabelHeightPadding, width:PICommunityButton.titleLabel!.frame.size.width, height: 4)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if self.revealViewController() != nil {
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            self.revealViewController().rearViewRevealWidth = self.view.frame.size.width
        }
        
        FacebookFeedQuery.sharedInstance.delegate = self
        FacebookFeedQuery.sharedInstance.getFeedFromPIMagazine()
    }
    
    override func viewDidAppear(animated: Bool) {
        if (purpleBarSelector == nil) {
            addPurpleSelectorBar()
        }
    }
    
    private func addPurpleSelectorBar() {
        purpleBarSelector = UIImageView(image: UIImage(named: "selector_MyPI"))
        purpleBarSelector.frame = CGRect(x: view.frame.width/4-18, y: myPIButton.frame.height + purpleBarSelectorBelowLabelHeightPadding, width:myPIButton.titleLabel!.frame.size.width, height: 4)
        view.addSubview(purpleBarSelector)
    }
    
    func tappedLabel(sender: UIGestureRecognizer) {
        println(firstObjectID)
        let postURL = "https://www.facebook.com/IN2PI/posts/1540303432891637"
        var wkWebView = UIWebView(frame: self.view.frame)
        wkWebView.loadRequest(NSURLRequest(URL: NSURL(string: postURL)!))
        var emptyVC = UIViewController()
        emptyVC.view = wkWebView
        navigationController?.pushViewController(emptyVC, animated: true)
    }
    
    func didFinishGettingFacebookFeedData(fbFeedObjectArray: [FBFeedObject]) {
        let firstObject = fbFeedObjectArray[0]
        firstObjectID = firstObject.id
        var tapGesture = UITapGestureRecognizer(target: self, action: Selector("tappedLabel:"))
        articleTitleLabel.userInteractionEnabled = true
        articleTitleLabel.addGestureRecognizer(tapGesture)
        
        var categoryStr = ""
        var firstTitleStr = ""
        let msg = firstObject.message
        if (!msg.isEmpty) {
            if (msg[0] == "[") {
                println("found open bracket")
                var categoryAppending = true
                for (var i=1; i < count(msg); i++) {
                    if (msg[i] == "]" || count(categoryStr) >= 100) {
                        //limit category string length
                        //categoryStr is now done ... move on to first line title string
                        categoryAppending = false
                        var j = i + 1
                        while (msg[j] != "\n") {
                            firstTitleStr += msg[j]
                            j += 1
                        }
                    }
                    if (categoryAppending) {
                        categoryStr += msg[i]
                    }
                }
            }
            self.articleCategoryLabel.text = categoryStr
            self.articleTitleLabel.text = firstTitleStr
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
            let date = dateFormatter.dateFromString(firstObject.created_time)
            if let date = date {
                dateFormatter.dateFormat = "yyyy-MM-dd EEE HH:mm a"
                self.articleDateLabel.text = dateFormatter.stringFromDate(date)
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}
