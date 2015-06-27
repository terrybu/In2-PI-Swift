//
//  HomeActionCollectionViewCell.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 6/27/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import UIKit

class HomeActionCollectionViewCell: UICollectionViewCell {
    
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes!) {
        
        self.layer.cornerRadius = 20
        
        self.contentView.layer.cornerRadius = 20.0
        self.contentView.layer.borderWidth = 1.5
        self.contentView.layer.borderColor = UIColor.grayColor().CGColor
        self.contentView.layer.masksToBounds = true
        
        self.layer.shadowOffset = CGSizeMake(0, 2.0);
        self.layer.shadowRadius = 5.0
        self.layer.shadowOpacity = 0.5
        self.layer.shadowColor = UIColor.whiteColor().CGColor
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).CGPath
        self.layer.shouldRasterize = true
    }
    
    
}
