//
//  ViewController.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 6/27/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController {
    
    
    @IBOutlet weak var myPIButton: UIButton!
    @IBOutlet weak var PICommunityButton: UIButton!
    
    var purpleBarSelector: UIImageView!
    
    
    @IBAction func myPIButtonPressed(sender: UIButton) {
        sender.setTitleColor(UIColor(rgba: "#9f5cc0"), forState: UIControlState.Normal)
        PICommunityButton.setTitleColor(UIColor(rgba: "#bbbcbc"), forState: UIControlState.Normal)
        
        purpleBarSelector.frame = CGRect(x: view.frame.width/4-18, y: myPIButton.frame.height + 2, width:myPIButton.titleLabel!.frame.size.width, height: 4)
    }
    
    
    @IBAction func PICommunityButtonPressed(sender: UIButton) {
        sender.setTitleColor(UIColor(rgba: "#9f5cc0"), forState: UIControlState.Normal)
        myPIButton.setTitleColor(UIColor(rgba: "#bbbcbc"), forState: UIControlState.Normal)
        
        purpleBarSelector.frame = CGRect(x: view.frame.width/2+48, y: myPIButton.frame.height + 2, width:PICommunityButton.titleLabel!.frame.size.width, height: 4)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
                
        purpleBarSelector = UIImageView(image: UIImage(named: "selector_MyPI"))
        let piButtonWidth = myPIButton.titleLabel!.frame.size.width
        println(piButtonWidth)
        println(PICommunityButton.frame.width)
        println(view.frame.width)
        purpleBarSelector.frame = CGRect(x: view.frame.width/4-piButtonWidth/2, y: myPIButton.frame.height + 4, width:piButtonWidth, height: 4)
        view.addSubview(purpleBarSelector)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}




