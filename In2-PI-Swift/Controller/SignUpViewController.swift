//
//  SignUpViewController.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 11/15/15.
//  Copyright © 2015 Terry Bu. All rights reserved.
//

import Parse
import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet var firstNameTextField:PaddedTextField!
    @IBOutlet var lastNameTextField:PaddedTextField!
    @IBOutlet var userNameTextField:PaddedTextField!
    @IBOutlet var passwordTextField:PaddedTextField!
    @IBOutlet var emailTextField:PaddedTextField!

    
    @IBAction func backArrowButton(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func signUpButtonPressed(sender: AnyObject) {
        let firstName = self.firstNameTextField.text
        let lastName = self.lastNameTextField.text
        let username = self.userNameTextField.text
        let password = self.passwordTextField.text
        let email = self.emailTextField.text
        // Validate the text fields
//        if username?.characters.count < 5 {
//            var alert = UIAlertView(title: "Invalid", message: "Username must be greater than 5 characters", delegate: self, cancelButtonTitle: "OK")
//            alert.show()
//            
//        } else 
//        if password?.characters.count < 8 {
//            var alert = UIAlertView(title: "Invalid", message: "Password must be greater than 8 characters", delegate: self, cancelButtonTitle: "OK")
//            alert.show()
        
//        } else 
        
        if email?.characters.count < 8 {
            let alert = UIAlertView(title: "Invalid", message: "Please enter a valid email address", delegate: self, cancelButtonTitle: "OK")
            alert.show()
            
        } else {
            // Run a spinner to show a task in progress
            let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
            spinner.startAnimating()
            
            let newUser = PFUser()
            newUser.username = username
            newUser.password = password
            newUser.setValue(firstName, forKey: "firstName")
            newUser.setValue(lastName, forKey: "lastName")
            newUser.setValue(email, forKey: "email")
            
            // Sign up the user asynchronously
            newUser.signUpInBackgroundWithBlock({ (succeed, error) -> Void in
                
                // Stop the spinner
                spinner.stopAnimating()
                if ((error) != nil) {
                    //error case
                    let alertController = UIAlertController(title: "Please Try Again", message: "\(error!.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
                    let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                    alertController.addAction(ok)
                    alertController.view.tintColor = UIColor.In2DeepPurple()
                    self.presentViewController(alertController, animated: true, completion: nil)
                } else {
                    //success case
                    let userName = PFUser.currentUser()!.username!
                    let alertController = UIAlertController(title: "Success", message: "\(userName)님, 가입/로그인에 성공하셨습니다", preferredStyle: UIAlertControllerStyle.Alert)
                    let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                    alertController.addAction(ok)
                    alertController.view.tintColor = UIColor.In2DeepPurple()
                    self.presentViewController(alertController, animated: true, completion: nil)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        //do some success navigation
                        let revealVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SWRevealViewController") as! SWRevealViewController
                        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                        appDelegate.window!.rootViewController = revealVC
                        appDelegate.setUpNavBarAndStatusBarImages()
                    })
                }
            })
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
