//
//  WorshipViewController.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 8/17/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import UIKit
import SafariServices
import AFNetworking
import SwiftyJSON

private let kOriginalAboutViewHeight: CGFloat = 32.0
private let kExpandedAboutViewHeight: CGFloat = 300.0
private let kOriginalContentViewHeight: CGFloat = 600

class WorshipViewController: ParentViewController, SFSafariViewControllerDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var contentView: UIView! //this property might not actually be needed ..
    @IBOutlet var expandableAboutView: ExpandableAboutView!
    @IBOutlet var songsTableView :     UITableView!
    @IBOutlet var weeklyProgramsTableView :     UITableView!
    var songsArray = [String]()
    var weeklyProgramsArray = [WeeklyProgram]()
    
    //Constraints
    @IBOutlet weak var constraintHeightExpandableView: NSLayoutConstraint!
    @IBOutlet weak var constraintContentViewHeight: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        setUpStandardUIForViewControllers()
        setUpExpandableAboutView()
        
        songsArray = ["Hillsong - Above All", "예수전도단 - 좋으신 하나님", "예수전도단 - 주 나의 왕"]
        
        getDataFromImportIOAPIForWeeklyPrograms()
        weeklyProgramsTableView.reloadData()
    }
    
    private func getDataFromImportIOAPIForWeeklyPrograms() {
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        manager.GET("https://api.import.io/store/data/3bc15cdb-dbc3-4e1a-b937-df3c2a68dbbc/_query?input/webpage/url=http%3A%2F%2Fvision.onnuri.org%2Fin2%2Farchives%2Fsunday_bulletin_category%2Fsunday-bulletin&_user=0a668a36-6aa0-4bf7-a33f-4aa867422551&_apikey=0a668a366aa04bf7a33f4aa86742255106cd4c765c1dc526570f30d171b722431f993ad7303c4f09ce394851f9fc53aecb7bf49dd2f2f02cd8e0624fa8dedf188642ab734d5c9159f291501b1b381633", parameters: nil,
            success: { (task:NSURLSessionDataTask!, responseObject:AnyObject!) -> Void in
                let jsonData = JSON(responseObject)
                let resultsArray = jsonData["results"].arrayValue
                print(resultsArray)
                for dict:JSON in resultsArray {
                    let title = dict["tit_link/_text"].stringValue
                    let datesArray = dict["tit_link_numbers"].arrayValue
                    let dateString = "\(datesArray[0].stringValue) \(datesArray[1].stringValue) \(datesArray[2].stringValue)"
                    let url = dict["tit_link"].stringValue
                    let newWeeklyProgram = WeeklyProgram(title: title, url: url, dateString: dateString)
                    self.weeklyProgramsArray.append(newWeeklyProgram)
                }
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.weeklyProgramsTableView.reloadData()
                    })
                })
            },
            failure: { (task:NSURLSessionDataTask!, error:NSError!) -> Void in
                print(error)
            })
    }
    
    private func setUpExpandableAboutView() {
        expandableAboutView.clipsToBounds = true
        expandableAboutView.delegate = ExpandableAboutViewHandler(viewControllerView: view, expandableView: expandableAboutView, constraintExpandableViewHeight: constraintHeightExpandableView, constraintContentViewHeight: constraintContentViewHeight, originalAboutViewHeight: kOriginalAboutViewHeight, expandedAboutViewHeight: kExpandedAboutViewHeight, originalContentViewHeight: kOriginalContentViewHeight)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        print("worship vc viewdidappear")
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
            return cell
        } else {
            let reuseIdentifier = "SongsTableViewCell"
            cell = songsTableView.dequeueReusableCellWithIdentifier(reuseIdentifier)!
            cell.textLabel!.text = songsArray[indexPath.row]
            return cell
        }
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
