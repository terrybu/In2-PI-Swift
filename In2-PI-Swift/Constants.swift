//
//  Constants.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 7/21/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

let Device = UIDevice.currentDevice()
let iosVersion = NSString(string: Device.systemVersion).doubleValue

let iOS8 = iosVersion >= 8
let iOS7 = iosVersion >= 7 && iosVersion < 8

