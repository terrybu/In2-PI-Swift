//
//  WeeklyProgramDownloader.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 9/22/15.
//  Copyright © 2015 Terry Bu. All rights reserved.
//

private let kImportIOURLForScrapingTenRecentWeeklyPrograms =  "https://api.import.io/store/data/3bc15cdb-dbc3-4e1a-b937-df3c2a68dbbc/_query?input/webpage/url=http%3A%2F%2Fvision.onnuri.org%2Fin2%2Farchives%2Fsunday_bulletin_category%2Fsunday-bulletin&_user=0a668a36-6aa0-4bf7-a33f-4aa867422551&_apikey=0a668a366aa04bf7a33f4aa86742255106cd4c765c1dc526570f30d171b722431f993ad7303c4f09ce394851f9fc53aecb7bf49dd2f2f02cd8e0624fa8dedf188642ab734d5c9159f291501b1b381633"

protocol WeeklyProgramDownloaderDelegate {
    func listOfTenWeeklyProgramsDownloadedFromImportIO()
    
}

class WeeklyProgramDownloader {
    
    static let sharedInstance = WeeklyProgramDownloader()
    var delegate: WeeklyProgramDownloaderDelegate?
    var weeklyProgramsListArray = [WeeklyProgram]()
    
    
    
}