//
//  WeeklyProgram.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 9/19/15.
//  Copyright © 2015 Terry Bu. All rights reserved.
//

import UIKit

class WeeklyProgram {
    //주보
    var title: String
    var pdfDownloadURL: String
    var dateString: String
    
    init(title: String, pdfDownloadURL: String, dateString: String) {
        self.title = title
        self.pdfDownloadURL = pdfDownloadURL
        self.dateString = dateString
    }
    

    
}
