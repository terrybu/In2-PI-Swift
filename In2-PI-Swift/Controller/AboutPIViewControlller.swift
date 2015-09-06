//
//  AboutPIViewControlller.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 8/29/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import UIKit

class AboutPIViewController: ParentViewController {
    
    var navDrawerVC : NavDrawerViewController?
    
    override func viewDidLoad() {

    }
    
    override func didMoveToParentViewController(parent: UIViewController?) {
        println("from about: width \(self.view.frame.width) height \(self.view.frame.height)")
        let button = UIButton(frame: CGRectMake(self.view.frame.width/2-15, self.view.frame.height-60, 30, 30))
        button.setImage(UIImage(named: "btn_close"), forState: .Normal)
        button.addTarget(self, action: "closeButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
        
        let titleLabel = UILabel(frame: CGRectMake(10, 10, 100, 100))
        titleLabel.text = "TESTING TESTING TESTING"
        self.view.addSubview(titleLabel)
    }
    
    //the reason this is private is because i wanted to keep it encapsulated
    //but then objective-c runtime can't find the method to use as selector
    //so you must use @objc keyword 
    @objc
    private func closeButtonPressed() {
        navDrawerVC?.closeAboutPIModal()
    }
    
}