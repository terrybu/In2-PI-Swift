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
        //        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //        appDelegate.statusBarBackgroundView?.hidden = true
    }
    
    
    override func viewDidLoad() {
        
        var hamburger = UIBarButtonItem(image: UIImage(named: "hamburger"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("hamburgerPressed:"))
        self.navigationItem.leftBarButtonItem = hamburger
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
    }
    
    
    
}
