//
//  WorshipViewController.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 8/17/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import UIKit
import WebKit

class WorshipViewController: ParentViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var expandableAboutView: ExpandableAboutView!
    @IBOutlet var jooboTableView : UITableView!
    
    var joobosArray = [String]()

    override func viewDidLoad() {
        setUpStandardUIForViewControllers()
        
//        let newView = ExpandableAboutView(frame: self.view.frame)
//        newView.aboutLabel.text = "About 예배부"
//        view.addSubview(newView)
//        expandableAboutView.aboutLabel.text = "sup"
        
        let test1 = "07/19/2015"
        let test2 = "07/12/2015"
        joobosArray = [test1, test2]
        jooboTableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 40))
        headerView.backgroundColor = UIColor.whiteColor()
        var label = UILabel(frame: CGRectMake(12, 5, 50, 18))
        label.text = "주보"
        headerView.addSubview(label)

        var button = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        button.frame = CGRectMake(tableView.frame.size.width-100, 5, 50, 20)
        button.setTitle("더보기", forState: UIControlState.Normal)
        button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        button.addTarget(self, action: "testTarget", forControlEvents: UIControlEvents.TouchUpInside)
        headerView.addSubview(button)
        
        var moreArrowButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        moreArrowButton.frame = CGRectMake(tableView.frame.size.width-50, 5, 50, 20)
        moreArrowButton.setImage(UIImage(named: "btn_more_B"), forState: .Normal)
        headerView.addSubview(moreArrowButton)
        return headerView
    }
    
    func testTarget() {
        println("testing")
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
//    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        var header:UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
//        var button = UIButton(frame: CGRectMake(0, 0, 50, 18))
//        button.titleLabel!.text = "test button"
//        view.addSubview(button)
////        view.tintColor = UIColor(rgba: "#2D2D2D")
////        header.textLabel.textColor = UIColor.bl()
//    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return joobosArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let reuseIdentifier = "JooboTableViewCell"
        let cell = jooboTableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as! UITableViewCell
        
        cell.textLabel!.text = joobosArray[indexPath.row]
        cell.accessoryView = UIImageView(image: UIImage(named: "btn_download"))
        return cell
    }
    
    
}
