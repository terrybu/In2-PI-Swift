//
//  WeeklyProgramDownloader.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 9/22/15.
//  Copyright © 2015 Terry Bu. All rights reserved.
//

import AFNetworking
import SwiftyJSON

private let kImportIOURLForScrapingTenRecentWeeklyPrograms =  "https://api.import.io/store/data/3bc15cdb-dbc3-4e1a-b937-df3c2a68dbbc/_query?input/webpage/url=http%3A%2F%2Fvision.onnuri.org%2Fin2%2Farchives%2Fsunday_bulletin_category%2Fsunday-bulletin&_user=0a668a36-6aa0-4bf7-a33f-4aa867422551&_apikey=0a668a366aa04bf7a33f4aa86742255106cd4c765c1dc526570f30d171b722431f993ad7303c4f09ce394851f9fc53aecb7bf49dd2f2f02cd8e0624fa8dedf188642ab734d5c9159f291501b1b381633"

protocol WeeklyProgramDownloaderDelegate {
    func didFinishDownloadinglistOfTenWeeklyProgramsFromImportIO(downloadedProgramsArray: [WeeklyProgram]?)
}

class WeeklyProgramDownloader {
    
    static let sharedInstance = WeeklyProgramDownloader()
    var delegate: WeeklyProgramDownloaderDelegate?
    var weeklyProgramsArray = [WeeklyProgram]()
    
    func getTenRecentWeeklyProgramsListFromImportIO() {
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        manager.GET(kImportIOURLForScrapingTenRecentWeeklyPrograms, parameters: nil,
            success: { (task:NSURLSessionDataTask!, responseObject:AnyObject!) -> Void in
                let jsonData = JSON(responseObject)
                let resultsArray = jsonData["results"].arrayValue
                print(resultsArray)
                for dict:JSON in resultsArray {
                    let title = dict["tit_link/_text"].stringValue
                    let datesArray = dict["txt_link_numbers/_source"].arrayValue
                    let dateString = datesArray.last?.stringValue
                    let url = dict["tit_link"].stringValue
                    let newWeeklyProgram = WeeklyProgram(title: title, url: url, dateString: dateString!)
                    self.weeklyProgramsArray.append(newWeeklyProgram)
                }
                self.delegate?.didFinishDownloadinglistOfTenWeeklyProgramsFromImportIO(self.weeklyProgramsArray)
            },
            failure: { (task:NSURLSessionDataTask!, error:NSError!) -> Void in
                print(error)
        })
    }
    
    func getURLStringForSingleProgramDownload(dateString: String) -> String {
        //my logic here needs work
        //this is not scalable because i'm basically guessing at the url format 
        //but a lot of things could go wrong where the URL gets messed up
        //*for example, if Samuel uploads on September a programme from AUgust, it will be under 29/2015/09/08/08.02 instead of 29/2015/08/08.02
        //instead you must go to that page, scrape to get the precise pdf link and then connect it here
        
        let base = "http://vision.onnuri.org/in2/wp-content/uploads/sites/29"
        //2015/08/08.02
        let year = dateString[6...9]
        let month = dateString[0...1]
        let monthDotDay = dateString[0...4]
        let ending = "-%EC%A3%BC%EB%B3%B4.pdf" //-주보web.pdf ... since early June, this formatting is always there .. (but not last day of May)
        
        return "\(base)/\(year)/\(month)/\(monthDotDay)\(ending)"
    }
//    
//    func getURLStringForSingleProgramDownloadWithoutEnding(dateString: String) -> String {
//        let base = "http://vision.onnuri.org/in2/wp-content/uploads/sites/29"
//        //2015/08/08.02
//        let year = dateString[6...9]
//        let month = dateString[0...1]
//        let monthDotDay = dateString[0...4]
//        
//        return "\(base)/\(year)/\(month)/\(monthDotDay).pdf"
//    }
    
}