//
//  AppDelegate.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 6/27/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import UIKit
import MediaPlayer
import HockeySDK
import AVKit
import Parse
import Bolts
import EAIntroView

private let sampleDescription1 = "Get latest updates on your favorite In2 PI stories and contents in MY FEED tab.";
private let sampleDescription2 = "Stay up to date on new things happening around In2 PI in the PI FEED tab.";
private let sampleDescription3 = "Tap the Menu icon to navigate around the app and access app settings.";

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, EAIntroDelegate {

    var window: UIWindow?
    var statusBarBackgroundView: UIView?
    var revealVCView: UIView!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // [Optional] Power your app with Local Datastore. For more info, go to
        // https://parse.com/docs/ios_guide#localdatastore/iOS
        Parse.enableLocalDatastore()
        // Initialize Parse.
        Parse.setApplicationId("kcmNwFnHHDfanE4xbzZYzufPe5Cz74z1O4wftbej",
            clientKey: "VYQRtVcSJWUhGhjuLuy8kA7HKQ7rzbHa7Y37Work")
 
        
        #if RELEASE
            print("release mode")
            BITHockeyManager.sharedHockeyManager().configureWithIdentifier   ("397fac4ea6ec1293bbf6b3aa1828b806")
            BITHockeyManager.sharedHockeyManager().startManager()
            BITHockeyManager.sharedHockeyManager().authenticator.authenticateInstallation()
            // [Optional] Track statistics around application opens.
            PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
            
            let movieURL = NSBundle.mainBundle().URLForResource("splashScreen", withExtension: "mp4")
            let moviePlayerItem = AVPlayerItem(URL: movieURL!)
            let moviePlayer = AVPlayer(playerItem: moviePlayerItem)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "moviePlayBackDidFinish", name: AVPlayerItemDidPlayToEndTimeNotification, object: moviePlayerItem)
            let playerController = AVPlayerViewController()
            playerController.player = moviePlayer
            playerController.showsPlaybackControls = false
            window?.rootViewController = playerController
            moviePlayer.play()
        #else
            print("debug mode")
            moviePlayBackDidFinish()
        #endif
     
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    @objc
    private func moviePlayBackDidFinish() {
        #if RELEASE
            let loginNavCtrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginVCNavigationController") as! UINavigationController
            let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
            loginVC.dismissBlock = {
                let revealVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SWRevealViewController") as! SWRevealViewController
                self.window?.rootViewController = revealVC
                print("dismiss block executing from appdelegate")
                self.setUpNavBarAndStatusBarImages()
            }
            loginNavCtrl.viewControllers = [loginVC]
            window?.rootViewController = loginNavCtrl
        #else
            //NO LOGIN FOR DEBUG JUST FOR NOW - comment it out to test Login screen
            
            //Walkthrough testing
            let walkthroughVC = UIViewController()
            walkthroughVC.view.frame = window!.frame
           // walkthroughVC.title = "Welcome"
//            let navigationCtrl = UINavigationController(rootViewController: walkthroughVC)
//            navigationCtrl.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
            //This below code gets rid of bottom 1px border from navigation bar, so we can make it look like a bottom border never exists
            //couldn't get the border to disappear for some reason. it stayed white.
//            navigationCtrl.navigationBar.setBackgroundImage(UIImage(), forBarPosition: UIBarPosition.Any, barMetrics: UIBarMetrics.Default)
//            navigationCtrl.navigationBar.shadowImage = UIImage()
//            navigationCtrl.navigationBar.clipsToBounds = true
//            navigationCtrl.navigationBar.translucent = false
            
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
            self.window?.rootViewController = walkthroughVC
        #endif
    }
    
    private func setUpPageForEAIntroPage(walkthroughVC: UIViewController, title: String, description: String, imageName: String) -> EAIntroPage {
        let page = EAIntroPage()
        page.title = title
        page.titlePositionY = walkthroughVC.view.frame.size.height - 30
        page.titleFont = UIFont(name: "NanumBarunGothicOTF", size: 21.0)
        page.desc = description
        page.descFont = UIFont(name: "NanumBarunGothicOTF", size: 20.0 * 6/8)
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
    func introDidFinish(introView: EAIntroView!) {
        print("intro walkthrough finished")
        let revealVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SWRevealViewController") as! SWRevealViewController
        self.window?.rootViewController = revealVC
        setUpNavBarAndStatusBarImages()

    }
    
    func setUpNavBarAndStatusBarImages() {
        UINavigationBar.appearance().setBackgroundImage(UIImage(named: "navigation_bar"), forBarMetrics: UIBarMetrics.Default)
        statusBarBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.size.width, height: 20))
        statusBarBackgroundView!.backgroundColor = UIColor(patternImage: UIImage(named:"status_bar")!)
        window?.rootViewController?.view.addSubview(statusBarBackgroundView!)
    }

    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }



}

