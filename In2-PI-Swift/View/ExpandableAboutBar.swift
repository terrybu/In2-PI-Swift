//
//  ExpandableAboutBar.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 9/5/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import UIKit

protocol ExpandableAboutBarDelegate {
    func didPressExpandButton()
}

//IBDesignable lets you use Interface Builder and Storyboard to see the changes you are making to your custom view right inside Storyboard after you make the change
//Without it, whatever changes you make in the XIB file of your custom view won't be seen in storyboard. Rather, storyboard will always just show the initial version of what your xib used to look like. IBDesignable lets you work around that. 

@IBDesignable class ExpandableAboutBar: UIView {
    
    var view: UIView!
    var delegate: ExpandableAboutBarDelegate?
    var expanded: Bool
    
    @IBOutlet weak var aboutLabel: UILabel!
    @IBAction func expandButtonPressed(sender: UIButton) {
        delegate?.didPressExpandButton()
    }
    
    //IBInspectable lets you read and write properties right in the inspector view of interface builder. Without it, there's no way for you to change properties of your custom view UI from storyboard
    @IBInspectable var title: String? {
        get {
            return aboutLabel.text
        }
        set(title) {
            aboutLabel.text = title
        }
    }
    
     override init(frame: CGRect) {
        self.expanded = false
        super.init(frame: frame)
        setUp()
    }
    
    required init(coder aDecoder: NSCoder) {
        self.expanded = false
        super.init(coder: aDecoder)
        setUp()
    }
    
    func setUp() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "ExpandableAboutBar", bundle: bundle)
        return nib.instantiateWithOwner(self, options: nil)[0] as! UIView
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
