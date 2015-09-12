//
//  NurtureViewController.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 8/29/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import UIKit
import MessageUI

class NurtureViewController: ParentViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var leftNurtureApplyWidget: ApplyWidgetView!
    @IBOutlet weak var rightHolyStarApplyWidget: ApplyWidgetView!
    
    override func viewDidLoad() {
        setUpStandardUIForViewControllers()
        leftNurtureApplyWidget.applyButtonPressedHandler = {(sender) -> Void in
            self.sendMail(sender)
        }
        rightHolyStarApplyWidget.applyButtonPressedHandler = {(sender) -> Void in
            self.sendMail(sender)
        }
    }
    
    @IBAction func sendMail(sender: AnyObject) {
        let picker = MFMailComposeViewController()
        picker.mailComposeDelegate = self
        picker.setToRecipients(["test@gmail.com"])
        picker.setSubject("신청서")
        picker.setMessageBody("texttexttexttexttexttexttexttexttexttext", isHTML: false)
        picker.navigationBar.tintColor = UIColor.whiteColor()
        picker.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]

        presentViewController(picker, animated: true, completion: {() -> Void in
//            var status = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.size.width, height: 20))
//            status.backgroundColor = UIColor(patternImage: UIImage(named:"status_bar")!)
//            self.navigationController!.navigationBar.barStyle
        })
        
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    

}
