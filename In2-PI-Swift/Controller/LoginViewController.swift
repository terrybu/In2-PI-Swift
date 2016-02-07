//
//  LoginViewController.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 10/19/15.
//  Copyright © 2015 Terry Bu. All rights reserved.
//

import UIKit
import MBProgressHUD

class LoginViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    var dismissBlock : (() -> Void)?
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBAction func signUpButtonWasPressed() {
        let signUpViewController = SignUpViewController()
        let signUpNavController = UINavigationController(rootViewController: signUpViewController)
        presentViewController(signUpNavController, animated: true, completion: nil)
    }
    
    convenience init() {
        self.init(nibName: "LoginViewController", bundle: nil)
        //initializing the view Controller form specified NIB file
    }
    
    override func viewDidLoad() {
        let backgroundGradientImageView = UIImageView(image: UIImage(named: "bg_gradient"))
        backgroundGradientImageView.frame = view.frame
        view.insertSubview(backgroundGradientImageView, atIndex: 0)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        let emailPlaceHolderStr = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName:UIColor(white: 1, alpha: 0.5)])
        emailTextField.attributedPlaceholder = emailPlaceHolderStr
        let passwordPlaceHolderStr = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName:UIColor(white: 1, alpha: 0.5)])
        passwordTextField.attributedPlaceholder = passwordPlaceHolderStr
        
        devBypassLogin()
    }
    
    private func devBypassLogin() {
        let rectangle = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        rectangle.backgroundColor = UIColor.clearColor()
        rectangle.userInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: "devGoThrough")
        rectangle.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
        view.addSubview(rectangle)
    }
    
    func devGoThrough() {
        FirebaseManager.sharedManager.loginUser("terry@test.com", password: "password") { (success) -> Void in
            if success {
                if let dismissBlock = self.dismissBlock {	
                    dismissBlock()
                }
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.navigationBar.hidden = true
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
    
    
    @IBAction func didPressLoginbutton() {
        let email = emailTextField.text
        let password = passwordTextField.text
        if let email = email, password = password{
            let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
            hud.labelText = "로그인 실행중입니다 ... 잠시만 기다려주세요."
            
            if adminMode() == true {
                //direct to admin page
                let adminVC = AdminViewController()
                let navCtrl = UINavigationController(rootViewController: adminVC)
                presentViewController(navCtrl, animated: true, completion: nil)
                return
            }
            
            FirebaseManager.sharedManager.loginUser(email, password: password, completion: { (success) -> Void in
                // completion
                if success {
                    if let dismissBlock = self.dismissBlock {
                        dismissBlock()
                    }
                } else {
                    let alertController = UIAlertController(title: "로그인 실패", message: "로그인이 실패하였습니다. 이메일과 비밀번호 입력을 다시 확인해 주세요.", preferredStyle: UIAlertControllerStyle.Alert)
                    let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                    alertController.addAction(ok)
                    alertController.view.tintColor = UIColor.In2DeepPurple()
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            })
        }
    }
    
    func adminMode() -> Bool {
        let email = emailTextField.text
        let password = passwordTextField.text
        if let email = email, password = password {
            if email == "admin" && password == "admin" {
                return true
            }
        }
        return false
    }
    
}
