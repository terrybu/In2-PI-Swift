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
//        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
//        let documentDirectory = paths[0]
//        let fileManager = NSFileManager.defaultManager()
//        var arrayOfSavedPDfTitles = [String]()
//        do {
//            try arrayOfSavedPDfTitles = fileManager.contentsOfDirectoryAtPath(documentDirectory)
//        }
//        catch let error as NSError {
//            error.description
//        }
        //I was in the process of trying to tell on WorshipVC tableview load which pdfs were already saved to documents directory and which weren't
        //But turns out these PDFs when they get saved to the doucments directory have original PDF file names so isn't it difficult to match up what's saved in documents directory to a program in the tableview row
        //This would be a nice to have but ... not an emergency for now.
        
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        manager.GET(kImportIOURLForScrapingTenRecentWeeklyPrograms, parameters: nil,
            success: { (task:NSURLSessionDataTask!, responseObject:AnyObject!) -> Void in
                let jsonData = JSON(responseObject)
                let resultsArray = jsonData["results"].arrayValue
                for dict:JSON in resultsArray {
                    let title = dict["tit_link/_text"].stringValue
                    var dateString: String
                    if dict["txt_link_numbers/_source"].arrayValue.count > 1 {
                        dateString = (dict["txt_link_numbers/_source"].arrayValue.last?.stringValue)!
                    } else {
                        dateString = dict["txt_link_numbers/_source"].stringValue
                    }
                    let pdfDownloadURL = dict["tit_link"].stringValue
                    let newWeeklyProgram = WeeklyProgram(title: title, pdfDownloadLinkPageOnnuriOrgURL: pdfDownloadURL, dateString: dateString)
                    self.weeklyProgramsArray.append(newWeeklyProgram)
                }
                self.delegate?.didFinishDownloadinglistOfTenWeeklyProgramsFromImportIO(self.weeklyProgramsArray)
            },
            failure: { (task:NSURLSessionDataTask!, error:NSError!) -> Void in
                print(error)
        })
    }
    /**
    This method goes through the entire HTML source file to get our direct downlaod PDF URL for weekly program on vision.onnuri.org.
    
    - parameter pdfDownloadPageURL: This is the url of the PAGE where the direct download URL resides
    
    - returns: PDF direct download link
    */
    func getURLStringForSingleProgramDownload(pdfDownloadPageURL: String) -> String?{
        //the logic in this method is not scalable because i'm basically guessing at the url format
        //but a lot of things could go wrong if the URL ever gets messed up
        //*for example, if Samuel uploads on September a programme from August, it will be under 29/2015/09/08/08.02 instead of 29/2015/08/08.02 due to wordpress rules
        //instead to be more exact, you must go to that page, scrape to get the precise pdf link and then connect it here
        //Anyhow, scraping off vision.onnuri.org to get these PDFs is a very brute-force method and only a temporary solution.
        
        let hppleParser = getSourceFileOfPageWithProgrammePDFDownloadLink(pdfDownloadPageURL)
        //basically we are parsing out the entire HTML document of the vision.onnuri.org page with the link to a single weekly program 
        //we are trying to identify the one link
        
        let xPathQueryString = "//div[@class='cview editor']/p"
        let divNodes = hppleParser?.searchWithXPathQuery(xPathQueryString) as! [TFHppleElement]
        for element: TFHppleElement in divNodes {
            for child: TFHppleElement in element.children as! [TFHppleElement
                ] {
                
                //Note that Hpple will not catch the link correctly sometimes because as you can see from our xPathQueryString above, we are looking for the case where the <a href> tag resides inside a div with class 'cview editor'
                //If somebody on the wordpress side makes a mistake and for some weird reason puts the <a href> tag inside another div, Hpple will fail to catch because <div class="cview editor"> will have ended prematurely
                    
                    
                if child.tagName == "a" {
                        let aHrefLinkStringForDirectDownloadPDF = child.objectForKey("href")
//                        print(aHrefLinkStringForDirectDownloadPDF)
                        //it gets tricky here to accommodate all edge cases
                        //usually, the pdf name would end with korean characters -주보
                        //but no, sometimes it's just like 11.27.2015
                    
                        //this forloop below should catch if korean characters was ever used in the PDF direct download URL and then return a sanitized version of that to return to WorshipVC
                        //for all other cases, shouldn't I just return the
                        let strLen = aHrefLinkStringForDirectDownloadPDF.characters.count
                        for var i = strLen-1; i >= 0; i-- {
                            let char = aHrefLinkStringForDirectDownloadPDF[i]
                            if char == "보" {
                                let koreanWordJooboSanitized = aHrefLinkStringForDirectDownloadPDF[i-1...i].stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
                                let beginning = aHrefLinkStringForDirectDownloadPDF[0...i-2]
                                let end = aHrefLinkStringForDirectDownloadPDF[i+1...strLen-1]
//                                print(beginning + koreanWordJooboSanitized! + end)
                                return beginning + koreanWordJooboSanitized! + end
                            }
                        }
                        //if this check goes through without last character equaling "보" 
                        //just return the aHrefLinkString
                        return aHrefLinkStringForDirectDownloadPDF
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