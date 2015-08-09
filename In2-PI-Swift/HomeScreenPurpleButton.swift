//
//  HomeScreenPurpleButton.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 8/8/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import UIKit

class HomeScreenPurpleButton: UIButton {

    func displayPurpleSelectionBarBelow() {
        let purpleBarSelector = UIImageView(image: UIImage(named: "selector_MyPI"))
        purpleBarSelector.frame = CGRect(x: self.frame.size.width, y: self.frame.size.height, width:self.titleLabel!.frame.size.width, height: 4)
        addSubview(purpleBarSelector)
    }
    
}
