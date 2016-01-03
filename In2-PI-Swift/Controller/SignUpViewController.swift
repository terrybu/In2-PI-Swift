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
    @IBOutlet var confirmPasswordTextField:PaddedTextField!
    @IBOutlet var emailTextField:PaddedTextField!
    @IBOutlet var birthdayDatePicker: UIDatePicker!

    convenience init() {
        self.init(nibName: "SignUpViewController", bundle: nil)
        //initializing the view Controller form specified NIB file
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "회원가입"
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        emailTextField.delegate = self
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navBarSignUp"), forBarMetrics: UIBarMetrics.Default)
        //for the longest time, I was wondering why sometimes navigation bar background would look a little lighter than the statusbar backround that Jin made me ... it was because they make it damn translucent by default
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        let statusBarBackgroundView = UIView(frame: CGRect(x: 0, y: -20, width: UIScreen.mainScreen().bounds.size.width, height: 20))
        statusBarBackgroundView.backgroundColor = UIColor(patternImage: UIImage(named:"status_bar")!)
        self.navigationController?.navigationBar.addSubview(statusBarBackgroundView)
        
        let backButton = UIBarButtonItem(image: UIImage(named: "btn_back"), style: UIBarButtonItemStyle.Plain, target: self, action: "backButtonPressed")
        navigationItem.leftBarButtonItem = backButton
    }
    
    func backButtonPressed() {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUpButtonPressed(sender: AnyObject) {
        let firstName = self.firstNameTextField.text
        let lastName = self.lastNameTextField.text
        let username = self.userNameTextField.text
        let password = self.passwordTextField.text
        let email = self.emailTextField.text
        // Validate the text fields
        if let username = username, password = password, email = email {
            if username.characters.count <= 3 {
                var alert = UIAlertView(title: "Invalid Username Input", message: "Username must be greater than 3 characters", delegate: self, cancelButtonTitle: "OK")
                alert.show()
                return
            } else {
                if password.characters.count <= 3 {
                    var alert = UIAlertView(title: "Invalid Password Input", message: "Password must be greater than 3 characters", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                    return
                }
            }
            if !isValidEmail(email) {
                let alert = UIAlertView(title: "Invalid Email Input", message: "Please enter a valid email address", delegate: self, cancelButtonTitle: "OK")
                alert.show()
                return
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
                        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
                        alertController.addAction(ok)
                        alertController.view.tintColor = UIColor.In2DeepPurple()
                        self.presentViewController(alertController, animated: true, completion: nil)
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            //Upon success, check if it's first time run, if it is, show walkthrough. If not, show home screen.
                            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                            WalkthroughManager.sharedInstance.checkFirstLaunchAndShowWalkthroughIfTrue(appDelegate.window)
                        })
                    }
                })
            }
        }
    }
    
    
    //MARK: UITextFieldDelegate Methods
    
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
    
    //Email validation
    func isValidEmail(testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }

}
