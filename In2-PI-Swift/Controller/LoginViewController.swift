//
//  LoginViewController.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 10/19/15.
//  Copyright © 2015 Terry Bu. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var dismissBlock : (() -> Void)?
    
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBAction func didPressLoginbutton() {
        let username = usernameTextField.text
        let password = passwordTextField.text
        
        if username != nil && password != nil {
            PFUser.logInWithUsernameInBackground(username!, password: password!) { (user, error) -> Void in
                if let user = user {
                    print(user)
                    if let dismissBlock = self.dismissBlock {
                        dismissBlock()
                    }
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
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        let usernamePlaceHolderStr = NSAttributedString(string: "Username", attributes: [NSForegroundColorAttributeName:UIColor(white: 1, alpha: 0.5)])
        usernameTextField.attributedPlaceholder = usernamePlaceHolderStr
        let passwordPlaceHolderStr = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName:UIColor(white: 1, alpha: 0.5)])
        passwordTextField.attributedPlaceholder = passwordPlaceHolderStr
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.navigationBarHidden = true
    }
    
    /**
    * Called when 'return' key pressed. return NO to ignore.
    */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /**
    * Called when the user click on the view (outside the UITextField).
    */
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
}
