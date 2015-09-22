//
//  WorshipViewController.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 8/17/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import UIKit
import SafariServices

private let kOriginalAboutViewHeight: CGFloat = 32.0
private let kExpandedAboutViewHeight: CGFloat = 300.0
private let kOriginalContentViewHeight: CGFloat = 600

class WorshipViewController: ParentViewController, WeeklyProgramDownloaderDelegate ,SFSafariViewControllerDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var contentView: UIView!
    @IBOutlet var expandableAboutView: ExpandableAboutView!
    @IBOutlet var songsTableView :     UITableView!
    @IBOutlet var weeklyProgramsTableView :     UITableView!
    var songsArray = [String]()
    var weeklyProgramsArray = [WeeklyProgram]()
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
    //Constraints
    @IBOutlet weak var constraintHeightExpandableView: NSLayoutConstraint!
    @IBOutlet weak var constraintContentViewHeight: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        setUpStandardUIForViewControllers()
        setUpExpandableAboutView()
        
        songsArray = ["Hillsong - Above All", "예수전도단 - 좋으신 하나님", "예수전도단 - 주 나의 왕"]
        
        if weeklyProgramsArray.isEmpty {
            indicator.center = CGPointMake(view.center.x, weeklyProgramsTableView.center.y)
            view.addSubview(indicator)
            indicator.startAnimating()
        }
        
        WeeklyProgramDownloader.sharedInstance.delegate = self
        WeeklyProgramDownloader.sharedInstance.getTenRecentWeeklyProgramsListFromImportIO()
    }
    
    private func setUpExpandableAboutView() {
        expandableAboutView.clipsToBounds = true
        expandableAboutView.delegate = ExpandableAboutViewHandler(viewControllerView: view, expandableView: expandableAboutView, constraintExpandableViewHeight: constraintHeightExpandableView, constraintContentViewHeight: constraintContentViewHeight, originalAboutViewHeight: kOriginalAboutViewHeight, expandedAboutViewHeight: kExpandedAboutViewHeight, originalContentViewHeight: kOriginalContentViewHeight)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        print("worship vc viewdidappear")
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
                label = UILabel(frame: CGRectMake(12, 5, 200, 18))
                label.text = "071915 예배 찬양 리스트"
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
            return 3
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
            cell.textLabel!.text = songsArray[indexPath.row]
        }
        return cell
    }
    
    //MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            if (tableView == weeklyProgramsTableView) {
                let joobo = weeklyProgramsArray[indexPath.row]
                print(joobo.dateString)

                let url : NSURL! = NSURL(string: "http://vision.onnuri.org/in2/wp-content/uploads/sites/29/2015/08/08.02-%EC%A3%BC%EB%B3%B4web.pdf")
                
                
                let webView = UIWebView(frame: view.frame)
                webView.loadRequest(NSURLRequest(URL: url))
                let vc = UIViewController()
                vc.view = webView
                navigationController?.pushViewController(vc, animated: true)
            }
            else if (tableView == songsTableView) {
                print("songs tv")
                let nameSong = songsTableView.cellForRowAtIndexPath(indexPath)?.textLabel!.text
                let escaped = nameSong!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
                let urlString = "https://www.youtube.com/results?search_query=" + escaped!
                let url : NSURL! = NSURL(string: urlString)

                if #available(iOS 9.0, *) {
                    let sfVC = SFSafariViewController(URL: url, entersReaderIfAvailable: true)
                    sfVC.delegate = self
                    //Show the browser
                    self.presentViewController(sfVC, animated: true, completion: nil)
                } else {
                    // Fallback on earlier versions
                    let webView = UIWebView(frame: view.frame)
                    webView.loadRequest(NSURLRequest(URL: url))
                    let vc = UIViewController()
                    vc.view = webView
                    navigationController?.pushViewController(vc, animated: true)
                }
            }
    }
    
    //Delegate method for dismissing it
    @available(iOS 9.0, *)
    func safariViewControllerDidFinish(controller: SFSafariViewController)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    

}
