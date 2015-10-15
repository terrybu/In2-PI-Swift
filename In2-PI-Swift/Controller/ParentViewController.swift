//
//  ParentViewController.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 8/29/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import UIKit

class ParentViewController: UIViewController {
    
    func hamburgerPressed(sender: UIBarButtonItem) {
        self.revealViewController().revealToggle(sender)
    }

    func homeButtonPressed() {
        let leftDrawer = revealViewController().rearViewController as! LeftNavDrawerController
        let homeNavCtrl = leftDrawer.homeVCNavCtrl
        revealViewController().pushFrontViewController(homeNavCtrl!, animated: true)
    }
    
    func setUpStandardUIForViewControllers() {
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        let hamburger = UIBarButtonItem(image: UIImage(named: "hamburger"), style: UIBarButtonItemStyle.Done, target: self, action: Selector("hamburgerPressed:"))
        navigationItem.leftBarButtonItem = hamburger
        
        let homeButton = UIBarButtonItem(image: UIImage(named: "home"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("homeButtonPressed"))
        navigationItem.rightBarButtonItem = homeButton
    }
    
    func setUpLeftNavDrawerMenuWidth() {
        if let revealVC = self.revealViewController() {
            revealVC.rearViewRevealWidth = self.view.frame.size.width
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        setUpLeftNavDrawerMenuWidth()
//        print("parent vc viewdidappear")
    }
    
    
}
