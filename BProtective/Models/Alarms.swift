//
//  Alarms.swift
//  BProtective
//
//  Created by Dustin Trinh on 2020-10-06.
//  Copyright © 2020 DustyTheCutie. All rights reserved.
//

import UIKit

class Alarms{
    
    var username: String
    var latitude: Double
    var longitude: Double
    var date: String
    var status: String
    
    init(username: String, lat: Double, lon: Double, date:String, status: String) {
        self.username = username
        self.latitude = lat
        self.longitude = lon
        self.date = date
        self.status = status
    }
}
