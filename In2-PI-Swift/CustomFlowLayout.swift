//
//  CustomFlowLayout.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 6/27/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

let TerryLabelKindSupplementary = "TerryLabelKind"

import UIKit

class CustomFlowLayout: UICollectionViewFlowLayout {
   
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        
        //first get a copy of all layout attributes that represent the cells. you will be modifying this collection.
        var allAttributes = super.layoutAttributesForElementsInRect(rect)
        
        //go through each cell attribute
        for attributes in super.layoutAttributesForElementsInRect(rect)!
        {
            //add a title and a detail supp view for each cell attribute to your copy of all attributes
            allAttributes?.append(self.layoutAttributesForSupplementaryViewOfKind(TerryLabelKindSupplementary, atIndexPath: attributes.indexPath))
        }
        
        //return the updated attributes list along with the layout info for the supp views
        return allAttributes;
    }
    
    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        //create a new layout attributes to represent this reusable view
        var attrs = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: TerryLabelKindSupplementary, withIndexPath: indexPath)
        
        //get the attributes for the related cell at this index path
        var cellAttrs = super.layoutAttributesForItemAtIndexPath(indexPath)
        
        if(elementKind == TerryLabelKindSupplementary){
            //position this reusable view relative to the cells frame
            var frame = cellAttrs.frame;
            frame.origin.y += (frame.size.height - 50);
            frame.size.height = 50;
            attrs.frame = frame;
        }
 
        
        return attrs;
    }
    
}
