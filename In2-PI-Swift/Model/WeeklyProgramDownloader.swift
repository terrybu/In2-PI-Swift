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
                    let pdfDownloadURL = dict["tit_link"].stringValue
                    let newWeeklyProgram = WeeklyProgram(title: title, pdfDownloadURL: pdfDownloadURL, dateString: dateString!)
                    self.weeklyProgramsArray.append(newWeeklyProgram)
                }
                self.delegate?.didFinishDownloadinglistOfTenWeeklyProgramsFromImportIO(self.weeklyProgramsArray)
            },
            failure: { (task:NSURLSessionDataTask!, error:NSError!) -> Void in
                print(error)
        })
    }
    
    func getURLStringForSingleProgramDownload(pdfDownloadURL: String) -> String?{
        //my logic here needs work
        //this is not scalable because i'm basically guessing at the url format 
        //but a lot of things could go wrong if the URL ever gets messed up
        //*for example, if Samuel uploads on September a programme from August, it will be under 29/2015/09/08/08.02 instead of 29/2015/08/08.02 due to wordpress rules
        //instead to be more exact, you must go to that page, scrape to get the precise pdf link and then connect it here
        
        let hppleParser = getSourceFileOfPageWithProgrammePDFDownloadLink(pdfDownloadURL)
        let xPathQueryString = "//div[@class='cview editor']/p"
        let divNodes = hppleParser?.searchWithXPathQuery(xPathQueryString) as! [TFHppleElement]
        for element: TFHppleElement in divNodes {
            for child: TFHppleElement in element.children as! [TFHppleElement
                ] {
                if child.tagName == "a" {
                        let answerString = child.objectForKey("href")
                        //need to sanitize it 
                        print(answerString)
                        let strLen = answerString.characters.count
                        for var i = strLen-1; i >= 0; i-- {
                            let char = answerString[i]
                            if char == "보" {
                                let koreanWordJooboSanitized = answerString[i-1...i].stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
                                let beginning = answerString[0...i-2]
                                let end = answerString[i+1...strLen-1]
                                print(beginning + koreanWordJooboSanitized! + end)
                                return beginning + koreanWordJooboSanitized! + end
                            }
                        }
                }
            }
        }
        
        return nil
    }

    private func getSourceFileOfPageWithProgrammePDFDownloadLink(pdfDownloadURL: String) -> TFHpple? {
        let data = NSData(contentsOfURL: NSURL(string: pdfDownloadURL)!)
        if let data = data {
            return TFHpple(HTMLData: data)
        }
        return nil
    }
}