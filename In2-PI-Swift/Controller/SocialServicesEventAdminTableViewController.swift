//
//  SocialServicesEventAdminTableViewController.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 2/7/16.
//  Copyright © 2016 Terry Bu. All rights reserved.
//

import UIKit

class SocialServicesEventAdminTableViewController: UITableViewController {
    
    var eventsArray: [SocialServiceEvent]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "긍휼부 스케줄"
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addSocialServiceEvent")
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(false)
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        activityIndicator.center = CGPointMake(view.center.x, 100)
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        FirebaseManager.sharedManager.getServiceEventObjectsFromFirebase({
            (success) -> Void in
            if (success) {
                self.eventsArray = FirebaseManager.sharedManager.eventsArray
                self.tableView.reloadData()
            }
            activityIndicator.stopAnimating()
        })
    }
    
    func addSocialServiceEvent() {
        print("new vc to add social service")
        let socialServiceEventCreationVC = SocialServicesEventCreationViewController()
        self.navigationController?.pushViewController(socialServiceEventCreationVC, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let eventsArray = eventsArray {
            return eventsArray.count
        }
        return 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "reuse")

        let event = eventsArray![indexPath.row]
        // Configure the cell...
        cell.textLabel!.text = event.title
        cell.detailTextLabel!.text = event.date

        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
