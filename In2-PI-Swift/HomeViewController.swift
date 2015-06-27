//
//  ViewController.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 6/27/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let name = String(format: NSLocalizedString("name", comment: ""))
        //this comment param for NSLocalizedString is really annoying and unnecessary because you can't set it to nil
        let msg = String(format: NSLocalizedString("Hello %@", comment: ""), name)
     
        println(msg)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

