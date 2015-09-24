//
//  ExpandableAboutViewHandlerswift
//  In2-PI-Swift
//
//  Created by Terry Bu on 9/12/15.
//  Copyright © 2015 Terry Bu. All rights reserved.
//

import UIKit

class ExpandableAboutViewHandler: ExpandableAboutViewDelegate {
    var viewControllerView: UIView
    var expandableView: ExpandableAboutView
    var constraintExpandableViewHeight: NSLayoutConstraint
    var constraintContentViewHeight: NSLayoutConstraint
    var originalAboutViewHeight: CGFloat
    var expandedAboutViewHeight: CGFloat
    var originalContentViewHeight: CGFloat
    
    init(viewControllerView: UIView, expandableView: ExpandableAboutView, constraintExpandableViewHeight: NSLayoutConstraint, constraintContentViewHeight: NSLayoutConstraint, originalAboutViewHeight: CGFloat, expandedAboutViewHeight: CGFloat, originalContentViewHeight: CGFloat) {
        
        self.viewControllerView = viewControllerView
        self.expandableView = expandableView
        self.constraintExpandableViewHeight = constraintExpandableViewHeight
        self.constraintContentViewHeight = constraintContentViewHeight
        self.originalAboutViewHeight = originalAboutViewHeight
        self.expandedAboutViewHeight = expandedAboutViewHeight
        self.originalContentViewHeight = originalContentViewHeight
    }
    
    func didPressExpandButton() {
        if !expandableView.expanded {
            print("did press expand button when it wasn't expanded")
            
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.constraintExpandableViewHeight.constant = self.expandedAboutViewHeight
                self.constraintContentViewHeight.constant += self.expandedAboutViewHeight - self.originalAboutViewHeight
                self.viewControllerView.layoutIfNeeded()
                
                }) { (Bool completed) -> Void in
                    self.expandableView.expanded = true
            }
        }
        else {
            print("did press expand button when it WAS expanded")
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.constraintExpandableViewHeight.constant = self.originalAboutViewHeight
                self.constraintContentViewHeight.constant =  self.originalContentViewHeight
                self.viewControllerView.layoutIfNeeded()
                
                }) { (Bool completed) -> Void in
                    self.expandableView.expanded = false
            }
        }
    }
    
}
