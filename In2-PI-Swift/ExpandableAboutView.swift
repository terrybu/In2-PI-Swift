//
//  ExpandableAboutView.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 9/5/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import UIKit

@IBDesignable class ExpandableAboutView: UIView {
    
    var view: UIView!
    
//    @IBOutlet weak var aboutLabel: UILabel!
//    @IBAction func expandButtonPressed(sender: UIButton) {
//    }
    
     override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init(coder aDecoder: NSCoder) {
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
        let nib = UINib(nibName: "ExpandableAboutView", bundle: bundle)
        return nib.instantiateWithOwner(self, options: nil)[0] as! UIView as UIView
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
