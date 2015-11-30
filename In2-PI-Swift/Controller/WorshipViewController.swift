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
import MBProgressHUD

private let kOriginalAboutViewHeight: CGFloat = 32.0
private let kOriginalContentViewHeight: CGFloat = 600

class WorshipViewController: ParentViewController, WeeklyProgramDownloaderDelegate ,SFSafariViewControllerDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var contentView: UIView!
    @IBOutlet var expandableAboutView: ExpandableAboutView!
    @IBOutlet var songsTableView :     UITableView!
    @IBOutlet var weeklyProgramsTableView :     UITableView!
    var songObjectsArray = [PraiseSong]()
    var weeklyProgramsArray = [WeeklyProgram]()
    var headerTitleStringForPraiseSongsListSection: String?
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
    //Constraints
    @IBOutlet weak var constraintHeightExpandableView: NSLayoutConstraint!
    @IBOutlet weak var constraintContentViewHeight: NSLayoutConstraint!
    var expandedAboutViewHeight:CGFloat = 0 
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        setUpStandardUIForViewControllers()
        
        expandedAboutViewHeight = expandableAboutView.aboutLabel.frame.size.height + expandableAboutView.textView.frame.size.height + 10
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
        let thisWeeksPraiseSongsListFeedPost: FBFeedPost
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
                    var newSongObject = PraiseSong(songTitle: newSongName)
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
    
    //MARK: WeeklyPrograms TableView Delegate methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 40))
            headerView.backgroundColor = UIColor.whiteColor()
            var label: UILabel
            if (tableView == weeklyProgramsTableView) {
                label = UILabel(frame: CGRectMake(12, 5, 50, 18))
                label.text = "주보"
            } else {
                label = UILabel(frame: CGRectMake(12, 5, 300, 18))
                if let headerTitle = headerTitleStringForPraiseSongsListSection {
                    label.text = headerTitle
                } else {
                    label.text = "인터넷 연결이 실패했습니다"
                }
            }
            label.font = UIFont.boldSystemFontOfSize(16)
            headerView.addSubview(label)
            
            let button = UIButton(type: UIButtonType.Custom)
            button.frame = CGRectMake(tableView.frame.size.width - 70, 5, 50, 20)
            button.setTitle("더보기", forState: UIControlState.Normal)
            button.titleLabel!.font = UIFont.boldSystemFontOfSize(16)
            button.setTitleColor(UIColor.In2DeepPurple(), forState: UIControlState.Normal)
            button.addTarget(self, action: "testTarget", forControlEvents: UIControlEvents.TouchUpInside)
            headerView.addSubview(button)
            
            let moreArrowButton = UIButton(type: UIButtonType.Custom)
            moreArrowButton.frame = CGRectMake(tableView.frame.size.width-30, 5, 30, 20)
            moreArrowButton.setImage(UIImage(named: "btn_more_B"), forState: .Normal)
            moreArrowButton.addTarget(self, action: "testTarget", forControlEvents: UIControlEvents.TouchUpInside)
            headerView.addSubview(moreArrowButton)
            return headerView
    }
    
    func testTarget() {
        print("testing")
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == weeklyProgramsTableView) {
            return weeklyProgramsArray.count
        } else if (tableView == songsTableView) {
            return songObjectsArray.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell
        
        if (tableView == weeklyProgramsTableView) {
            let reuseIdentifier = "WeeklyProgramsTableViewCell"
            cell = weeklyProgramsTableView.dequeueReusableCellWithIdentifier(reuseIdentifier)!
                cell.textLabel!.text = weeklyProgramsArray[indexPath.row].title
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
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            if tableView == weeklyProgramsTableView {
                let weeklyProgram = weeklyProgramsArray[indexPath.row]
                
                if weeklyProgram.cached  {
                    displayPDFInWebView(NSURL.fileURLWithPath(weeklyProgram.cachedPath!))
                } else {
                    let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
                    print(weeklyProgram.pdfDownloadLinkPageOnnuriOrgURL)
                    //weeklyProgram.pdfDownloadURL has the PAGE on vision.onnuri.org that contains the link to the PDF. 
                    //a weeklyProgram object from our weeklyprogramsArray is retrieved from import.io scraper I made that just searches for a list of URLs to hit to get to the LINK page
                    
                    let pdfdownloadURLString = WeeklyProgramDownloader.sharedInstance.getURLStringForSingleProgramDownload(weeklyProgram.pdfDownloadLinkPageOnnuriOrgURL)
                    if let pdfdownloadURLString = pdfdownloadURLString {
                        let url = NSURL(string:pdfdownloadURLString)
                        HttpFileDownloader.sharedInstance.loadFileAsync(url!, completion:{(path:String, error:NSError!) in
                            if error == nil {
                                print("pdf downloaded to: \(path)")
                                weeklyProgram.cached = true
                                weeklyProgram.cachedPath = path
                                let fileURL = NSURL.fileURLWithPath(path)
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                                    self.displayPDFInWebView(fileURL)
                                })
                            } else if error.code == 404 {
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                                    let alertController = UIAlertController(title: "Downloading Problem", message: "Oops! Looks like that file is not available right now :(", preferredStyle: UIAlertControllerStyle.Alert)
                                    let okay = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
                                    alertController.addAction(okay)
                                    self.presentViewController(alertController, animated: true, completion: nil)
                                })
                            }
                        })
                    }
                }
            } else if tableView == songsTableView {
                //below was when we were just doing a general search of the praise song name on youtube as a query and showing user the results
//                let nameSong = songsTableView.cellForRowAtIndexPath(indexPath)?.textLabel!.text
//                let escaped = nameSong!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
//                let urlString = "https://www.youtube.com/results?search_query=" + escaped!
//                let url : NSURL! = NSURL(string: urlString)
                let songObject = songObjectsArray[indexPath.row]
                let url = NSURL(string: songObject.songYouTubeURL!)
                
                if #available(iOS 9.0, *) {
                    let sfVC = SFSafariViewController(URL: url!, entersReaderIfAvailable: true)
                    sfVC.delegate = self
                    self.presentViewController(sfVC, animated: true, completion: nil)
                    //in case anybody prefers right to left push viewcontroller animation transition (below) 
//                    navigationController?.pushViewController(sfVC, animated: true)

                } else {
                    // Fallback on earlier versions
                    let webView = UIWebView(frame: view.frame)
                    webView.loadRequest(NSURLRequest(URL: url!))
                    let vc = UIViewController()
                    vc.view = webView
                    navigationController?.pushViewController(vc, animated: true)
                }
            }
    }
    private func displayPDFInWebView(fileURL: NSURL) {
        let webView = UIWebView(frame: self.view.frame)
        webView.scalesPageToFit = true
        webView.loadRequest(NSURLRequest(URL: fileURL))
        let vc = UIViewController()
        vc.view = webView
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //Delegate method for dismissing safari vc
    @available(iOS 9.0, *)
    func safariViewControllerDidFinish(controller: SFSafariViewController)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
