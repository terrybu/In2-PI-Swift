//
//  LeftNavDrawerController.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 7/25/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import UIKit

class LeftNavDrawerController: UIViewController {
    
    //MARK: Properties 
    var purpleStatusBar: UIView!
    var maskView : UIView!
    var aboutVCModal : AboutPIViewController!
    var homeVCNavCtrl: UINavigationController?
    var worshipVCNavCtrl: UINavigationController?
    var nurtureVCNavCtrl: UINavigationController?
    var communicationsVCNavCtrl: UINavigationController?
    var evangelismVCNavCtrl: UINavigationController?
    var socialServicesVCNavCtrl: UINavigationController?
    var galleryVCNavCtrl: UINavigationController?
    
    var tapOutOfModalGesture: UIGestureRecognizer!
    var swipeGestureRightToLeft: UISwipeGestureRecognizer!

    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        purpleStatusBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.size.width, height: 20))
        purpleStatusBar.backgroundColor = UIColor.In2DeepPurple()
        appDelegate.window?.rootViewController?.view.addSubview(purpleStatusBar)
        
        let homeNavCtrl = self.revealViewController().frontViewController as! UINavigationController
        self.homeVCNavCtrl = homeNavCtrl
        
        // Do any additional setup after loading the view.
        let backgroundImageView = UIImageView(image: UIImage(named:"navDrawerBackground"))
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
        swipeGestureRightToLeft = UISwipeGestureRecognizer(target: self, action: "userJustSwipedFromRightToLeft:")
        swipeGestureRightToLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeGestureRightToLeft)
    }
    
    override func viewWillAppear(animated: Bool) {
        purpleStatusBar.hidden = false
    }
    
    
    func userJustSwipedFromRightToLeft(gesture: UISwipeGestureRecognizer) {
        if (gesture.direction == UISwipeGestureRecognizerDirection.Left) {
            print("swiped left")
            purpleStatusBar.hidden = true
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
            self.view.removeGestureRecognizer(self.tapOutOfModalGesture)
            self.view.addGestureRecognizer(self.swipeGestureRightToLeft)
        }
    }
    
    func handleTap(gestureRecognizer: UIGestureRecognizer) {
        let location = gestureRecognizer.locationInView(self.view)
        print("from navdrawer handleTap \(location)")
        if (location.y < self.aboutVCModal.view.frame.origin.y) || (location.y > self.aboutVCModal.view.frame.height + self.aboutVCModal.view.frame.origin.y) || (location.x > self.aboutVCModal.view.frame.width + self.aboutVCModal.view.frame.origin.x) || (location.x < self.aboutVCModal.view.frame.origin.x) {
            closeAboutPIModal()
        }
    }
    
    // MARK: IBActions
    
    @IBAction
    func xButtonPressed(sender: AnyObject) {
        purpleStatusBar.hidden = true
        self.revealViewController().revealToggle(sender)
    }
    
    @IBAction
    func worshipButtonPressed(sender: UIButton) {
        if worshipVCNavCtrl == nil {
            worshipVCNavCtrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("WorshipNavController") as? UINavigationController
        }
        purpleStatusBar.hidden = true
        revealViewController().pushFrontViewController(worshipVCNavCtrl, animated: true)
    }
    
    @IBAction
    func nurtureButtonPressed(sender: UIButton) {
        if nurtureVCNavCtrl == nil {
            nurtureVCNavCtrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("NurtureNavController") as? UINavigationController
        }
        purpleStatusBar.hidden = true
        revealViewController().pushFrontViewController(nurtureVCNavCtrl, animated: true)
    }
    
    @IBAction
    func communicationsButtonPressed(sender: UIButton) {
        if communicationsVCNavCtrl == nil {
            communicationsVCNavCtrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CommunicationsNavController") as? UINavigationController
        }
        purpleStatusBar.hidden = true
        revealViewController().pushFrontViewController(communicationsVCNavCtrl, animated: true)
    }
    
    @IBAction
    func evangelismButtonPressed(sender: UIButton) {
        if evangelismVCNavCtrl == nil {
            evangelismVCNavCtrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("EvangelismNavController") as? UINavigationController
        }
        purpleStatusBar.hidden = true
        revealViewController().pushFrontViewController(evangelismVCNavCtrl, animated: true)
    }
    
    @IBAction
    func socialServicesButtonPressed(sender: UIButton) {
        if socialServicesVCNavCtrl == nil {
            socialServicesVCNavCtrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SocialServicesNavController") as? UINavigationController
        }
        purpleStatusBar.hidden = true
        revealViewController().pushFrontViewController(socialServicesVCNavCtrl, animated: true)
    }
    
    @IBAction
    func galleryButtonPressed(sender: UIButton) {
        if galleryVCNavCtrl == nil {
            galleryVCNavCtrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("GalleryNavController") as? UINavigationController
        }
        purpleStatusBar.hidden = true
        revealViewController().pushFrontViewController(galleryVCNavCtrl, animated: true)
    }
    
    @IBAction
    func aboutPIButtonPressed(sender: UIButton) {
        self.view.removeGestureRecognizer(self.swipeGestureRightToLeft)
        
        aboutVCModal = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("AboutPIViewController") as! AboutPIViewController
        aboutVCModal.navDrawerVC = self
        self.addChildViewController(aboutVCModal)
        
        maskView = UIView(frame: self.view.frame)
        maskView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(maskView)
        
        let modalWidth = self.view.frame.width-40
        let modalHeight = self.view.frame.height-100
        aboutVCModal.view.frame = CGRectMake(20, self.view.frame.height, modalWidth, modalHeight)
        self.view.addSubview(aboutVCModal.view)
        aboutVCModal.didMoveToParentViewController(self)
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.aboutVCModal.view.frame = CGRectMake(20, 80, modalWidth, modalHeight)
            self.maskView.backgroundColor = UIColor.blackColor()
            self.maskView.alpha  = 0.60
            }) { (Bool finished) -> Void in
                self.tapOutOfModalGesture = UITapGestureRecognizer(target: self, action: "handleTap:")
                self.view.addGestureRecognizer(self.tapOutOfModalGesture)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
