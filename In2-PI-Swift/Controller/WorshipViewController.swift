//
//  WorshipViewController.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 8/17/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import UIKit
import WebKit


class WorshipViewController: ParentViewController, UITableViewDelegate, UITableViewDataSource, ExpandableAboutBarDelegate {

    @IBOutlet var contentView: UIView! 
    @IBOutlet var expandableAboutBar: ExpandableAboutBar!
    @IBOutlet var songsTableView :     UITableView!
    @IBOutlet var jooboTableView :     UITableView!
    var hiddenExpandingView: UIView!
    var songsArray = [String]()
    var joobosArray = [String]()
    
    //Constraints
    @IBOutlet weak var constraintContentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintVerticalSpacingBarToTableview: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        setUpStandardUIForViewControllers()
    
        expandableAboutBar.title = "About 예배부"
        expandableAboutBar.delegate = self
        
        songsArray = ["Hillsong - Above All", "예수전도단 - 좋으신 하나님", "예수전도단 - 주 나의 왕"]
        let test1 = "07/19/2015"
        let test2 = "07/12/2015"
        joobosArray = [test1, test2]
        jooboTableView.reloadData()
    }
    
    //MARK: ExpandableAboutBar methods
    func didPressExpandButton() {
        if !expandableAboutBar.expanded {
            println("did press expand button when it wasn't expanded")
            hiddenExpandingView = ExpandingAboutView(frame: CGRectMake(0, self.expandableAboutBar.frame.origin.y + self.expandableAboutBar.frame.size.height, self.view.frame.width, 0), titleString: "test", introductionText: "test")
            hiddenExpandingView.clipsToBounds = true

            self.contentView.addSubview(hiddenExpandingView)
            hiddenExpandingView.backgroundColor = UIColor.whiteColor()
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                var newFrame = self.hiddenExpandingView.frame
                newFrame.size.height += 200
                self.hiddenExpandingView.frame = newFrame
                self.constraintVerticalSpacingBarToTableview.constant += 200
                self.constraintContentViewHeight.constant += 200
                self.view.layoutIfNeeded()
                
                }) { (Bool completed) -> Void in
                   self.expandableAboutBar.expanded = true
            }
        }
        else {
            println("did press expand button when it WAS expanded")
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                var newFrame = self.hiddenExpandingView.frame
                newFrame.size.height = 0
                self.hiddenExpandingView.frame = newFrame
                self.constraintVerticalSpacingBarToTableview.constant -= 200
                self.constraintContentViewHeight.constant -= 200
                self.view.layoutIfNeeded()
                }) { (Bool completed) -> Void in
                    self.expandableAboutBar.expanded = false
                }
        }
    }
    
    //MARK: Joobo TableView Delegate methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            var headerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 40))
            headerView.backgroundColor = UIColor.whiteColor()
            var label: UILabel
            if (tableView == jooboTableView) {
                label = UILabel(frame: CGRectMake(12, 5, 50, 18))
                label.text = "주보"
            } else {
                label = UILabel(frame: CGRectMake(12, 5, 200, 18))
                label.text = "071915 예배 찬양 리스트"
            }
            label.font = UIFont.boldSystemFontOfSize(16)
            headerView.addSubview(label)
            
            var button = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
            button.frame = CGRectMake(tableView.frame.size.width - 70, 5, 50, 20)
            button.setTitle("더보기", forState: UIControlState.Normal)
            button.titleLabel!.font = UIFont.boldSystemFontOfSize(16)
            button.setTitleColor(UIColor.In2DeepPurple(), forState: UIControlState.Normal)
            button.addTarget(self, action: "testTarget", forControlEvents: UIControlEvents.TouchUpInside)
            headerView.addSubview(button)
            
            var moreArrowButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
            moreArrowButton.frame = CGRectMake(tableView.frame.size.width-30, 5, 30, 20)
            moreArrowButton.setImage(UIImage(named: "btn_more_B"), forState: .Normal)
            moreArrowButton.addTarget(self, action: "testTarget", forControlEvents: UIControlEvents.TouchUpInside)
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
        if (tableView == jooboTableView) {
            return joobosArray.count
        } else if (tableView == songsTableView) {
            return 3
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell
        
        if (tableView == jooboTableView) {
            let reuseIdentifier = "JooboTableViewCell"
            cell = jooboTableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as! UITableViewCell
            cell.textLabel!.text = joobosArray[indexPath.row]
            cell.accessoryView = UIImageView(image: UIImage(named: "btn_download"))
            return cell
        } else {
            let reuseIdentifier = "SongsTableViewCell"
            cell = songsTableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as! UITableViewCell
            cell.textLabel!.text = songsArray[indexPath.row]
            return cell
        }
    }
    
    
}
