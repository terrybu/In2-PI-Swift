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
        self.title = "주보"
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let programsArray = allWeeklyProgramsArray {
            return programsArray.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "AllWeeklyProgramsTableViewCellIdentifier")
        if let programsArray = allWeeklyProgramsArray {
            let program = programsArray[indexPath.row]
            cell.textLabel?.text = program.title
            cell.accessoryView = UIImageView(image: UIImage(named: "btn_download"))
        }
        return cell
    }
    
    
}
