//
//  LoginViewController.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 10/19/15.
//  Copyright © 2015 Terry Bu. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBAction func didPressLoginbutton() {
        let username = usernameTextField.text
        let password = passwordTextField.text
        
        if username != nil && password != nil {
            PFUser.logInWithUsernameInBackground(username!, password: password!) { (user, error) -> Void in
                if let user = user {
                    print(user)
                    self.dismissViewControllerAnimated(false, completion: { () -> Void in
                        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                        appDelegate.revealVCView.hidden = false
                    })
                    
                } else {
                    print(error)
                }
            }
        }
     
    }
    
    override func viewDidLoad() {
        let backgroundGradientImageView = UIImageView(image: UIImage(named: "bg_gradient"))
        backgroundGradientImageView.frame = view.frame
        view.insertSubview(backgroundGradientImageView, atIndex: 0)
        
        let usernamePlaceHolderStr = NSAttributedString(string: "Username", attributes: [NSForegroundColorAttributeName:UIColor(white: 1, alpha: 0.5)])
        usernameTextField.attributedPlaceholder = usernamePlaceHolderStr
        let passwordPlaceHolderStr = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName:UIColor(white: 1, alpha: 0.5)])
        passwordTextField.attributedPlaceholder = passwordPlaceHolderStr
    }
    
    
    
}
