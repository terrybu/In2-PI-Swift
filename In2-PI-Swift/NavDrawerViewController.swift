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
    
    @IBAction
    func worshipButtonPressed(sender: UIButton) {
        let nav = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("WorshipNavController") as! UINavigationController
        revealViewController().pushFrontViewController(nav, animated: true)
    }
    
    @IBAction
    func nurtureButtonPressed(sender: UIButton) {
        let nav = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("NurtureNavController") as! UINavigationController
        revealViewController().pushFrontViewController(nav, animated: true)
    }
    
    @IBAction
    func communicationsButtonPressed(sender: UIButton) {
        let nav = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CommunicationsNavController") as! UINavigationController
        revealViewController().pushFrontViewController(nav, animated: true)
    }
    
    @IBAction
    func evangelismButtonPressed(sender: UIButton) {
        let nav = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("EvangelismNavController") as! UINavigationController
        revealViewController().pushFrontViewController(nav, animated: true)
    }
    
    @IBAction
    func socialServicesButtonPressed(sender: UIButton) {
        let nav = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SocialServicesNavController") as! UINavigationController
        revealViewController().pushFrontViewController(nav, animated: true)
    }
    
    @IBAction
    func aboutPIButtonPressed(sender: UIButton) {
        let nav = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("AboutPINavController") as! UINavigationController
        revealViewController().pushFrontViewController(nav, animated: true)
    }
    
    @IBAction
    func galleryButtonPressed(sender: UIButton) {
        let nav = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("GalleryNavController") as! UINavigationController
        revealViewController().pushFrontViewController(nav, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let backgroundImageView = UIImageView(image: UIImage(named:"navDrawerBackground"))
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)

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
