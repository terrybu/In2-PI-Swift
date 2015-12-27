//
//  WorshipViewController.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 8/17/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import UIKit
import SafariServices
import Foundation

private let kOriginalContentViewHeight: CGFloat = 1000

class WorshipViewController: ParentViewController, WeeklyProgramDownloaderDelegate ,SFSafariViewControllerDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var contentView: UIView!
    @IBOutlet var expandableAboutView: ExpandableAboutView!
    @IBOutlet var songsTableView :     UITableView!
    @IBOutlet var weeklyProgramsTableView :     UITableView!
    var songObjectsArray = [PraiseSong]()
    
    var weeklyProgramsArray = [WeeklyProgram]()
    var thisMonthProgramsArray = [WeeklyProgram]()
    
    var headerTitleStringForPraiseSongsListSection: String?
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
    //Constraints
    @IBOutlet weak var constraintHeightExpandableView: NSLayoutConstraint!
    @IBOutlet weak var constraintContentViewHeight: NSLayoutConstraint!
    var expandedAboutViewHeight:CGFloat = 0 
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        setUpStandardUIForViewControllers()
        setUpExpandableAboutView()
        
        getPraiseSongNamesListAndHeaderFromFacebook()
        
        if weeklyProgramsArray.isEmpty {
            indicator.center = CGPointMake(view.center.x, weeklyProgramsTableView.center.y)
            view.addSubview(indicator)
            indicator.startAnimating()
        }
        
        WeeklyProgramDownloader.sharedInstance.delegate = self
        WeeklyProgramDownloader.sharedInstance.getTenRecentWeeklyProgramsListFromImportIO()
    }
    
    func getPraiseSongNamesListAndHeaderFromFacebook() {
        let feedPostObjects = FacebookFeedQuery.sharedInstance.FBFeedObjectsArray
        for postObject in feedPostObjects {
            if postObject.parsedCategory == "PI찬양" {
                if postObject.type == "status" {
                    parseEachLineOfPraiseSongPostBodyMessageToFillSongsArray(postObject.message)
                    headerTitleStringForPraiseSongsListSection = postObject.parsedTitle
                    break
                }
            }
        }
    }
    
    /**
    This method parses out the message body of a facebook post with category "PI찬양" so that it detects song names and their respective youtube URLs
    
    - parameter postBody: Body message of the post
    */
    private func parseEachLineOfPraiseSongPostBodyMessageToFillSongsArray(postBody: String) {
        var i = 0
        var newSongName = ""
        while i < postBody.characters.count {
            if postBody[i] == "\n" {
                if postBody[i+1] == "\n" {
                    //found a double linebreak
                    let newSongObject = PraiseSong(songTitle: newSongName)
                    var j = i + 2
                    newSongName = ""
                    while postBody[j] != "\n" {
                        newSongName += postBody[j]
                        j++
                    }
                    newSongObject.songTitle = newSongName
                    //this is where we can start the logic after we end the first "songtitle" scraping? because j+1 is now the youtube URL
                    var k = j + 1
                    var newYouTubeURL = ""
                    while k < postBody.characters.count && postBody[k] != "\n" {
                        newYouTubeURL += postBody[k]
                        k++
                    }
                    newSongObject.songYouTubeURL = newYouTubeURL
                    songObjectsArray.append(newSongObject)
                }
            }
            i++
        }
        print(songObjectsArray)
    }
    
    
    private func setUpExpandableAboutView() {
        expandedAboutViewHeight = kOriginalAboutViewHeight + expandableAboutView.textView.frame.size.height + 30
        expandableAboutView.clipsToBounds = true
        expandableAboutView.delegate = ExpandableAboutViewHandler(viewControllerView: view, expandableView: expandableAboutView, constraintExpandableViewHeight: constraintHeightExpandableView, constraintContentViewHeight: constraintContentViewHeight, originalAboutViewHeight: kOriginalAboutViewHeight, expandedAboutViewHeight: expandedAboutViewHeight, originalContentViewHeight: kOriginalContentViewHeight)
    }
    
    //MARK: WeeklyProgramDownloader Delegate methods
    func didFinishDownloadinglistOfTenWeeklyProgramsFromImportIO(downloadedProgramsArray: [WeeklyProgram]?) {
        if let downloadedProgramsArray = downloadedProgramsArray {
            self.weeklyProgramsArray = downloadedProgramsArray
            weeklyProgramsTableView.reloadData()
            indicator.stopAnimating()
            weeklyProgramsTableView.hidden = false
        }
    }
    
    //MARK: UITableViewDataSource Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == weeklyProgramsTableView) {
            let today = NSDate()
            let calendar = NSCalendar.currentCalendar()
            let todayComponents = calendar.components([.Day , .Month , .Year], fromDate: today)
            let todaysMonth = todayComponents.month //this will give you today's month
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM.dd.yyyy"
            for program in weeklyProgramsArray {
                if let dateProgramString = program.dateString {
                    let dateProgramNSDate = dateFormatter.dateFromString(dateProgramString)
                    if let dateProgramNSDate = dateProgramNSDate {
                        print(dateProgramNSDate)
                        let thisProgramDateComponents = calendar.components([.Day, .Month, .Year], fromDate: dateProgramNSDate)
                        if thisProgramDateComponents.month == todaysMonth {
                            print(thisProgramDateComponents)
                            thisMonthProgramsArray.append(program)
                        }
                    }
                }
            }
            return thisMonthProgramsArray.count
        } else if (tableView == songsTableView) {
            return songObjectsArray.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if (tableView == weeklyProgramsTableView) {
            let program = thisMonthProgramsArray[indexPath.row]
            cell = weeklyProgramsTableView.dequeueReusableCellWithIdentifier(kWeeklyProgramsTableViewCellReuseIdentifier)!
            cell.textLabel!.text = program.title
            cell.accessoryView = UIImageView(image: UIImage(named: "btn_download"))
        } else {
            let reuseIdentifier = "SongsTableViewCell"
            cell = songsTableView.dequeueReusableCellWithIdentifier(reuseIdentifier)!
            let songObject = songObjectsArray[indexPath.row]
            cell.textLabel!.text = songObject.songTitle!
        }
        return cell
    }
    
    //MARK: UITableViewDelegate
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 40))
        headerView.backgroundColor = UIColor.whiteColor()
        var label: UILabel
        if (tableView == weeklyProgramsTableView) {
            label = UILabel(frame: CGRectMake(12, 5, 50, 18))
            label.text = "주보"
            //"See more arrow button" to the right of section header
            let button = UIButton(type: UIButtonType.Custom)
            button.frame = CGRectMake(tableView.frame.size.width - 70, 5, 50, 20)
            button.setTitle("더보기", forState: UIControlState.Normal)
            button.titleLabel!.font = UIFont.boldSystemFontOfSize(16)
            button.setTitleColor(UIColor.In2DeepPurple(), forState: UIControlState.Normal)
            button.addTarget(self, action: "seeMoreArrowWasPressedForWeeklyProgramsTableView", forControlEvents: UIControlEvents.TouchUpInside)
            headerView.addSubview(button)
            //This is the same function as "더보기" just to the right of the text.
            let moreArrowButton = UIButton(type: UIButtonType.Custom)
            moreArrowButton.frame = CGRectMake(tableView.frame.size.width-30, 5, 30, 20)
            moreArrowButton.setImage(UIImage(named: "btn_more_B"), forState: .Normal)
            moreArrowButton.addTarget(self, action: "seeMoreArrowWasPressedForWeeklyProgramsTableView", forControlEvents: UIControlEvents.TouchUpInside)
            headerView.addSubview(moreArrowButton)
        } else {
            label = UILabel(frame: CGRectMake(12, 5, 300, 18))
            if let headerTitle = headerTitleStringForPraiseSongsListSection {
                label.text = headerTitle
            } else {
                label.text = "인터넷 연결이 실패했습니다"
            }
        }
        label.font = UIFont.boldSystemFontOfSize(17)
        headerView.addSubview(label)
        
        return headerView
    }
    
    func seeMoreArrowWasPressedForWeeklyProgramsTableView() {
        print("seeMoreArrowWasPressed")
        performSegueWithIdentifier("AllWeeklyProgramsTableViewControllerSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AllWeeklyProgramsTableViewControllerSegue" {
            let programsVC = segue.destinationViewController as! AllWeeklyProgramsTableViewController
            programsVC.allWeeklyProgramsArray = self.weeklyProgramsArray
        }
        self.navigationItem.backBarButtonItem?.title = ""
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == weeklyProgramsTableView {
            let weeklyProgram = thisMonthProgramsArray[indexPath.row]
            WeeklyProgramDisplayManager.sharedInstance.displayWeeklyProgramLogic(weeklyProgram, view: self.view, navController: self.navigationController!, viewController: self)
        }
        else if tableView == songsTableView {
            let songObject = songObjectsArray[indexPath.row]
            if let songURLString = songObject.songYouTubeURL {
                let trimSpacesFromURLString = songURLString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                let url = NSURL(string: trimSpacesFromURLString)
                if let url = url {
                    presentSFSafariVCIfAvailable(url)
                }
            }
        }
    }
    
    private func presentSFSafariVCIfAvailable(url: NSURL) {
        if #available(iOS 9.0, *) {
            let sfVC = SFSafariViewController(URL: url, entersReaderIfAvailable: true)
            sfVC.delegate = self
            self.presentViewController(sfVC, animated: true, completion: nil)
            //in case anybody prefers right to left push viewcontroller animation transition (below)
            //navigationController?.pushViewController(sfVC, animated: true)
        } else {
            // Fallback on earlier versions
            let webView = UIWebView(frame: view.frame)
            webView.loadRequest(NSURLRequest(URL: url))
            let vc = UIViewController()
            vc.view = webView
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    

    
    //Delegate method for dismissing safari vc
    @available(iOS 9.0, *)
    func safariViewControllerDidFinish(controller: SFSafariViewController)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: IBActions
    @IBAction func didPressSeeMoreWorshipVideos() {
        presentSFSafariVCIfAvailable(NSURL(string: "https://www.youtube.com/user/in2ube/videos")!)
    }
    
}
