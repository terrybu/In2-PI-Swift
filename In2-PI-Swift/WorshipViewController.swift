//
//  WorshipViewController.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 8/17/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import UIKit

class WorshipViewController: UIViewController {
    
    @IBAction func hamburgerPressed(sender: UIBarButtonItem) {
        self.revealViewController().revealToggle(sender)
    }
    
    func homeButtonPressed() {
        let rootNav = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("RootNavController") as! UINavigationController
        revealViewController().pushFrontViewController(rootNav, animated: true)
    }
    
    
    override func viewDidLoad() {
        if self.revealViewController() != nil {
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            self.revealViewController().rearViewRevealWidth = self.view.frame.size.width-20
        }
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()

        let hamburger = UIBarButtonItem(image: UIImage(named: "hamburger"), style: UIBarButtonItemStyle.Done, target: self, action: Selector("hamburgerPressed:"))
        self.navigationItem.leftBarButtonItem = hamburger
        
        let homeButton = UIBarButtonItem(image: UIImage(named: "home"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("homeButtonPressed"))
        self.navigationItem.rightBarButtonItem = homeButton

    }
    
    
    
}
