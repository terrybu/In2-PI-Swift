//
//  AllWeeklyProgramsTableViewController
//  In2-PI-Swift
//
//  Created by Terry Bu on 12/26/15.
//  Copyright © 2015 Terry Bu. All rights reserved.
//

import UIKit

class AllWeeklyProgramsTableViewController: UITableViewController {

    var allWeeklyProgramsArray: [WeeklyProgram]?
    
    override func viewDidLoad() {
        self.title = "주보 보기"
        let homeButton = UIBarButtonItem(image: UIImage(named: "home"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("homeButtonPressed"))
        navigationItem.rightBarButtonItem = homeButton
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let allWeeklyProgramsArray = allWeeklyProgramsArray {
            return allWeeklyProgramsArray.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "AllWeeklyProgramsTableViewCellIdentifier")
        let program = allWeeklyProgramsArray![indexPath.row]
        cell.textLabel?.text = program.title
        cell.accessoryView = UIImageView(image: UIImage(named: "btn_download"))
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let weeklyProgram = allWeeklyProgramsArray![indexPath.row]
        WeeklyProgramDisplayManager.sharedInstance.displayWeeklyProgramLogic(weeklyProgram, view: view, navController: self.navigationController!, viewController: self)
    }
    
    func homeButtonPressed() {
        let leftDrawer = revealViewController().rearViewController as! LeftNavDrawerController
        let homeNavCtrl = leftDrawer.homeVCNavCtrl
        revealViewController().pushFrontViewController(homeNavCtrl!, animated: true)
    }
    
    
}
