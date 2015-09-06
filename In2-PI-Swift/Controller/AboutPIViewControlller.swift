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
    
    override func didMoveToParentViewController(parent: UIViewController?) {
//        println("from about: width \(self.view.frame.width) height \(self.view.frame.height)")
        
        let titleLabel = UILabel(frame: CGRectMake(15, 50, self.view.frame.width-30, 25))
        titleLabel.text = "목회 철학"
        titleLabel.font = UIFont(name: "NanumBarunGothicOTFBold", size: 25)
        self.view.addSubview(titleLabel)

        let introLabel = UILabel(frame: CGRectMake(15, 90, self.view.frame.width-30, self.view.frame.height-100))
        introLabel.numberOfLines = 0
        introLabel.text = "예수 그리스도가 주인인 공동체를 이루는 것이 온누리교회의 목회철학입니다. 성경적인 공동체는 바로 예수 공동체입니다. 예수 그리스도가 주인이 되신 공동체요, 예수 그리스도를 위해 존재하는 공동체입니다. 온누리교회는 예배 공동체, 성령 공동체, 선교 공동체를 이루어 이 시대의 참된 예수 공동체로 존재하기를 추구하고 있습니다."
        introLabel.sizeToFit() 
        self.view.addSubview(introLabel)
        
        let button = UIButton(frame: CGRectMake(self.view.frame.width/2-15, self.view.frame.height-60, 30, 30))
        button.setImage(UIImage(named: "btn_close"), forState: .Normal)
        button.addTarget(self, action: "closeButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
    }
    
    //the reason this is private is because i wanted to keep it encapsulated
    //but then objective-c runtime can't find the method to use as selector
    //so you must use @objc keyword 
    @objc
    private func closeButtonPressed() {
        navDrawerVC?.closeAboutPIModal()
    }
    
}