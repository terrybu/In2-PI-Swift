//
//  WorshipViewController.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 8/17/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import UIKit
import WebKit


class WorshipViewController: ParentViewController, UITableViewDelegate, UITableViewDataSource, ExpandableAboutViewDelegate {

    @IBOutlet var expandableAboutView: ExpandableAboutView!
    @IBOutlet var songsTableView :     UITableView!
    @IBOutlet var jooboTableView :     UITableView!
    var joobosArray = [String]()

    override func viewDidLoad() {
        setUpStandardUIForViewControllers()
    
        expandableAboutView.title = "About 예배부"
        expandableAboutView.delegate = self
        
        let test1 = "07/19/2015"
        let test2 = "07/12/2015"
        joobosArray = [test1, test2]
        jooboTableView.reloadData()
    }
    
    //MARK: Expandable View methods
    func didPressExpandButton() {
        println("did press expand button")
    }
    
    //MARK: Joobo TableView Delegate methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 40))
        headerView.backgroundColor = UIColor.whiteColor()
        var label = UILabel(frame: CGRectMake(12, 5, 50, 18))
        label.text = "주보"
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
            return 4
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
            cell.textLabel!.text = "songs"
            return cell
        }
    }
    
    
}
