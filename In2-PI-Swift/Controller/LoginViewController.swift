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
