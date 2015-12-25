//
//  WalkthroughManager.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 12/13/15.
//  Copyright © 2015 Terry Bu. All rights reserved.
//

import UIKit
import EAIntroView

private let sampleDescription1 = "Get latest updates on your favorite In2 PI stories and contents in MY FEED tab.";
private let sampleDescription2 = "Stay up to date on new things happening around In2 PI in the PI FEED tab.";
private let sampleDescription3 = "Tap the Menu icon to navigate around the app and access app settings.";

class WalkthroughManager: NSObject, EAIntroDelegate{
    
    static let sharedInstance = WalkthroughManager()
    
    func displayWalkthroughScreen(window: UIWindow?) {
        let walkthroughVC = WalkthroughViewController()
        walkthroughVC.view.frame = window!.frame
        let page1 = setUpPageForEAIntroPage(walkthroughVC, title: "Welcome", description: sampleDescription1, imageName: "walkthroughImage1")
        let page2 = setUpPageForEAIntroPage(walkthroughVC, title: "PI Feed", description: sampleDescription2, imageName: "walkthroughImage2") ;
        let page3 = setUpPageForEAIntroPage(walkthroughVC, title: "Navigation Drawer", description: sampleDescription3, imageName: "walkthroughImage3") ;
        
        let introView = EAIntroView(frame: walkthroughVC.view.frame, andPages: [page1,page2,page3])
        //if you want to the navigation bar way
        //let introView = EAIntroView(frame: walkthroughVC.view.frame, andPages: [page1,page2,page3,page4])
        introView.delegate = self
        introView.pageControlY = walkthroughVC.view.frame.size.height - 30 - 48 - 64;
        introView.bgImage = UIImage(named: "bg_gradient")
        let btn = UIButton(type: UIButtonType.Custom)
        btn.setBackgroundImage(UIImage(named: "btn_X"), forState: UIControlState.Normal)
        btn.frame = CGRectMake(0, 0, 24, 20)
        introView.skipButton = btn
        introView.skipButtonY = walkthroughVC.view.frame.size.height - 30
        introView.skipButtonAlignment = EAViewAlignment.Right
        
        introView.showInView(walkthroughVC.view, animateDuration: 0.3)
        window?.rootViewController = walkthroughVC
    }
    
    func checkFirstLaunchAndShowWalkthroughIfTrue(window: UIWindow?) {
        let firstLaunch = NSUserDefaults.standardUserDefaults().boolForKey(kfirstLaunchKeyForWalkthroughCheck)
        if firstLaunch == false {
            print("Not first launch. Take him straight to login or home screen without walkthrough")
            showHomeScreen()
        }
        else {
            print("First launch, setting NSUserDefault AND displaying walkthrough screen")
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: kfirstLaunchKeyForWalkthroughCheck)
            WalkthroughManager.sharedInstance.displayWalkthroughScreen(window)
        }
    }
    
    private func setUpPageForEAIntroPage(walkthroughVC: UIViewController, title: String, description: String, imageName: String) -> EAIntroPage {
        let page = EAIntroPage()
        page.title = title
        page.titlePositionY = walkthroughVC.view.frame.size.height - 30
        page.titleFont = UIFont(name: "NanumBarunGothic", size: 21.0)
        page.desc = description
        page.descFont = UIFont(name: "NanumBarunGothic", size: 20.0 * 6/8)
        page.descWidth = walkthroughVC.view.frame.size.width * 0.75
        //setting position on these work weirdly. Higher the number, Higher it goes up toward top of screen. Lower the number, more it sticks to bottom of screen
        page.descPositionY = walkthroughVC.view.frame.size.height - 30 - 32
        let walkthroughImageView = UIImageView(image: UIImage(named: imageName))
        page.titleIconView = walkthroughImageView
        if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS{
            page.titleIconPositionY = walkthroughVC.view.frame.size.height - walkthroughImageView.frame.size.height + 50
        } else {
            page.titleIconPositionY = walkthroughVC.view.frame.size.height - walkthroughImageView.frame.size.height
        }
        return page
    }
    
    //MARK: EAIntroViewDelegate
    @objc func introDidFinish(introView: EAIntroView!) {
        print("intro walkthrough finished or wasn't needed")
        showHomeScreen()
    }
    
    func showHomeScreen() {
        let revealVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SWRevealViewController") as! SWRevealViewController
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController = revealVC
        appDelegate.setUpNavBarAndStatusBarImages()
    }
    
}