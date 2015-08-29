//
//  HomeScreenViewController.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 8/29/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import UIKit

private let purpleBarSelectorBelowLabelHeightPadding:CGFloat = 4

class HomeScreenViewController: UIViewController {
    
    @IBOutlet weak var myPIButton: UIButton!
    @IBOutlet weak var PICommunityButton: UIButton!
    @IBOutlet weak var hamburgerButton: UIBarButtonItem!
    @IBOutlet weak var articleTitleLabel:UILabel!
    @IBOutlet weak var articldDateLabel: UILabel!
    @IBOutlet weak var articleAuthorLabel: UILabel!
    @IBOutlet weak var QTTitleLabel: UILabel!
    
    var purpleBarSelector: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if self.revealViewController() != nil {
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            self.revealViewController().rearViewRevealWidth = self.view.frame.size.width
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        addPurpleSelectorBar()
    }
    
    private func addPurpleSelectorBar() {
        purpleBarSelector = UIImageView(image: UIImage(named: "selector_MyPI"))
        purpleBarSelector.frame = CGRect(x: view.frame.width/4-18, y: myPIButton.frame.height + purpleBarSelectorBelowLabelHeightPadding, width:myPIButton.titleLabel!.frame.size.width, height: 4)
        view.addSubview(purpleBarSelector)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: IBActions
    
    @IBAction func hamburgerPressed(sender: UIBarButtonItem) {
        self.revealViewController().revealToggle(sender)
        //        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //        appDelegate.statusBarBackgroundView?.hidden = true
    }
    
    @IBAction func myPIButtonPressed(sender: UIButton) {
        sender.setTitleColor(UIColor(rgba: "#9f5cc0"), forState: UIControlState.Normal)
        PICommunityButton.setTitleColor(UIColor(rgba: "#bbbcbc"), forState: UIControlState.Normal)
        
        purpleBarSelector.frame = CGRect(x: view.frame.width/4-18, y: myPIButton.frame.height + purpleBarSelectorBelowLabelHeightPadding, width:myPIButton.titleLabel!.frame.size.width, height: 4)
    }
    
    
    @IBAction func PICommunityButtonPressed(sender: UIButton) {
        sender.setTitleColor(UIColor(rgba: "#9f5cc0"), forState: UIControlState.Normal)
        myPIButton.setTitleColor(UIColor(rgba: "#bbbcbc"), forState: UIControlState.Normal)
        
        purpleBarSelector.frame = CGRect(x: view.frame.width/2+48, y: myPIButton.frame.height + purpleBarSelectorBelowLabelHeightPadding, width:PICommunityButton.titleLabel!.frame.size.width, height: 4)
    }
    
}
