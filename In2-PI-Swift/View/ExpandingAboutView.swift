//
//  ExpandingAboutView.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 9/7/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import UIKit

class ExpandingAboutView: UIView {
    var titleString: String?
    var introductionText: String?
    
    init(frame: CGRect, titleString: String, introductionText: String) {
        self.titleString = titleString
        self.introductionText = introductionText
        super.init(frame: frame)
        setUpSubViews()
    }
    
    private func setUpSubViews() {
        let titleLabel = UILabel(frame: CGRectMake(15, 10, frame.width-30, 25))
        titleLabel.text = titleString
        titleLabel.font = UIFont(name: "NanumBarunGothicOTFBold", size: 25)
        addSubview(titleLabel)
        let introLabel = UILabel(frame: CGRectMake(15, 50, frame.width-30, 50))
        introLabel.numberOfLines = 0
        introLabel.text = introductionText
        introLabel.sizeToFit()
        addSubview(introLabel)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
