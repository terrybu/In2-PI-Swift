//
//  NavDrawerViewController.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 7/25/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import UIKit

class NavDrawerViewController: UIViewController {
    
    @IBAction
    func xButtonPressed(sender: AnyObject) {
//        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        appDelegate.statusBarBackgroundView?.hidden = false
        self.revealViewController().revealToggle(sender)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let backgroundImageView = UIImageView(image: UIImage(named:"navDrawerBackground"))
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
        
//        if self.revealViewController() != nil {
//            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
