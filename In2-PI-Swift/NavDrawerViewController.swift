//
//  NavDrawerViewController.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 7/25/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import UIKit

class NavDrawerViewController: UIViewController {
    
    var maskView : UIView!
    var aboutVCModal : AboutPIViewController!
    var galleryVCNavCtrl: UINavigationController?
    var homeVCNavCtrl: UINavigationController?
    var worshipVCNavCtrl: UINavigationController?
    var nurtureVCNavCtrl: UINavigationController?
    var communicationsVCNavCtrl: UINavigationController?
    var evangelismVCNavCtrl: UINavigationController?
    var socialServicesVCNavCtrl: UINavigationController?

    @IBAction
    func xButtonPressed(sender: AnyObject) {
//        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        appDelegate.statusBarBackgroundView?.hidden = false
        self.revealViewController().revealToggle(sender)
    }
    
    
    @IBAction
    func worshipButtonPressed(sender: UIButton) {
        if worshipVCNavCtrl == nil {
            worshipVCNavCtrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("WorshipNavController") as? UINavigationController
        }
        revealViewController().pushFrontViewController(worshipVCNavCtrl, animated: true)
    }
    
    @IBAction
    func nurtureButtonPressed(sender: UIButton) {
        if nurtureVCNavCtrl == nil {
            nurtureVCNavCtrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("NurtureNavController") as? UINavigationController
        }
        revealViewController().pushFrontViewController(nurtureVCNavCtrl, animated: true)
    }
    
    @IBAction
    func communicationsButtonPressed(sender: UIButton) {
        if communicationsVCNavCtrl == nil {
            communicationsVCNavCtrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CommunicationsNavController") as? UINavigationController
        }
        revealViewController().pushFrontViewController(communicationsVCNavCtrl, animated: true)
    }
    
    @IBAction
    func evangelismButtonPressed(sender: UIButton) {
        if evangelismVCNavCtrl == nil {
            evangelismVCNavCtrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("EvangelismNavController") as? UINavigationController
        }
        revealViewController().pushFrontViewController(evangelismVCNavCtrl, animated: true)
    }
    
    @IBAction
    func socialServicesButtonPressed(sender: UIButton) {
        if socialServicesVCNavCtrl == nil {
            socialServicesVCNavCtrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SocialServicesNavController") as? UINavigationController
        }
        revealViewController().pushFrontViewController(socialServicesVCNavCtrl, animated: true)
    }
    
    @IBAction
    func aboutPIButtonPressed(sender: UIButton) {
        aboutVCModal = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("AboutPIViewController") as! AboutPIViewController
        aboutVCModal.navDrawerVC = self
        self.addChildViewController(aboutVCModal)

        maskView = UIView(frame: self.view.frame)
        maskView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(maskView)
        
        aboutVCModal.view.frame = CGRectMake(20, self.view.frame.height, self.view.frame.width-40, self.view.frame.height-100)
        self.view.addSubview(aboutVCModal.view)
        aboutVCModal.didMoveToParentViewController(self)

        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.aboutVCModal.view.frame = CGRectMake(20, 80, self.view.frame.width-40, self.view.frame.height-100)
            self.maskView.backgroundColor = UIColor.blackColor()
            self.maskView.alpha  = 0.60

        }) { (Bool finished) -> Void in
            
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTap:")
            self.view.addGestureRecognizer(gestureRecognizer)
        }
    }
    
    @IBAction
    func galleryButtonPressed(sender: UIButton) {
        if galleryVCNavCtrl == nil {
            galleryVCNavCtrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("GalleryNavController") as? UINavigationController
        }
        revealViewController().pushFrontViewController(galleryVCNavCtrl, animated: true)
    }
    
    //MARK VC Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var homeNavCtrl = self.revealViewController().frontViewController as! UINavigationController
        self.homeVCNavCtrl = homeNavCtrl
        
        // Do any additional setup after loading the view.
        let backgroundImageView = UIImageView(image: UIImage(named:"navDrawerBackground"))
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: "userJustSwipedFromRightToLeft:")
        swipeGesture.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeGesture)
    }
    
    func userJustSwipedFromRightToLeft(gesture: UISwipeGestureRecognizer) {
        if (gesture.direction == UISwipeGestureRecognizerDirection.Left) {
            println("swiped left")
            self.revealViewController().revealToggleAnimated(true)
        }
    }
    
    
    //MARK: about PI Modal
    func closeAboutPIModal() {
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.aboutVCModal.view.frame = CGRectMake(20, self.view.frame.height, self.view.frame.width-40, self.view.frame.height-100)
            self.maskView.backgroundColor = UIColor.clearColor()
            self.maskView.alpha = 1.0
        }) { (Bool finished) -> Void in
            self.aboutVCModal.view.removeFromSuperview()
            self.aboutVCModal.removeFromParentViewController()
            self.maskView.removeFromSuperview()
        }
    }
    
    func handleTap(gestureRecognizer: UIGestureRecognizer) {
        let location = gestureRecognizer.locationInView(self.view)
        println("from navdrawer handleTap \(location)")
        if (location.y < self.aboutVCModal.view.frame.origin.y) || (location.y > self.aboutVCModal.view.frame.height + self.aboutVCModal.view.frame.origin.y) || (location.x > self.aboutVCModal.view.frame.width + self.aboutVCModal.view.frame.origin.x) || (location.x < self.aboutVCModal.view.frame.origin.x) {
            closeAboutPIModal()
        }
    }
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
