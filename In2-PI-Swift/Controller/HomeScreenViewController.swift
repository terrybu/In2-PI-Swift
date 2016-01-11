//
//  HomeScreenViewController.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 8/29/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import UIKit
import MBProgressHUD

class HomeScreenViewController: ParentViewController, FacebookFeedQueryDelegate {
    
    // MARK: Properties
    var black: UIView!
    var firstObjectID: String!
    var imageBlackOverlay: UIView?
    @IBOutlet weak var newsArticleView: NewsArticleView!

    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUniqueUIForHomeVC()
        
        blackOverlayUntilFBDataFinishedLoading()
        FacebookFeedQuery.sharedInstance.delegate = self
        FacebookFeedQuery.sharedInstance.getFeedFromPIMagazine { (error) -> Void in
            if error != nil {
                print(error.description)
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            }
        }
//        print("view did load + \(newsArticleView.backgroundImageView.frame.size)")
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
        hud.labelText = "로딩중입니다. 잠시만 기다려주세요."
    }
    
    func tappedNewsArticleView(sender: UIGestureRecognizer) {
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
    func didFinishGettingFacebookFeedData(fbFeedObjectArray: [FBFeedPost]) {
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("tappedNewsArticleView:"))
        newsArticleView.userInteractionEnabled = true
        newsArticleView.addGestureRecognizer(tapGesture)
        
        let firstObject = fbFeedObjectArray[0]
        newsArticleView.categoryLabel.text = firstObject.parsedCategory
        newsArticleView.titleLabel.text = firstObject.parsedTitle
        newsArticleView.dateLabel.text = firstObject.parsedDate
        firstObjectID = firstObject.id
        if firstObject.type == "photo" {
            FacebookPhotoQuery.sharedInstance.getNormalSizePhotoURLStringForCommunicationsFrom(firstObject.id, completion: { (normImgUrlString) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.newsArticleView.backgroundImageView.setImageWithURL(NSURL(string: normImgUrlString))
                })
            })
        }
        self.black.removeFromSuperview()
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
