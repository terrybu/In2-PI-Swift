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
        let rootNav = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("RootNavController") as! UINavigationController
        revealViewController().pushFrontViewController(rootNav, animated: true)
    }
    
    func setUpStandardUIForViewControllers() {
        if let revealVC = self.revealViewController() {
            self.view.addGestureRecognizer(revealVC.panGestureRecognizer())
            self.view.addGestureRecognizer(revealVC.tapGestureRecognizer())
            revealVC.rearViewRevealWidth = self.view.frame.size.width
        }
        
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        let textAttributes = NSMutableDictionary(capacity:1)
        textAttributes.setObject(UIColor.whiteColor(), forKey: NSForegroundColorAttributeName)
        navigationController?.navigationBar.titleTextAttributes = textAttributes as [NSObject : AnyObject]
        
        let hamburger = UIBarButtonItem(image: UIImage(named: "hamburger"), style: UIBarButtonItemStyle.Done, target: self, action: Selector("hamburgerPressed:"))
        navigationItem.leftBarButtonItem = hamburger
        
        let homeButton = UIBarButtonItem(image: UIImage(named: "home"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("homeButtonPressed"))
        navigationItem.rightBarButtonItem = homeButton
    }
        
    
}
