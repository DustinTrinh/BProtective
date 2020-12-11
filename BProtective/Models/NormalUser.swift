//
//  NormalUser.swift
//  BProtective
//
//  Created by Dustin Trinh on 2020-09-15.
//  Copyright © 2020 DustyTheCutie. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class NormalUser: Location, User{
    
    var uid: String
    var username: String
    var email: String
    var role: String
    var status: String
    var loc: Location
    
    func setUID(uid: String){
        self.uid = uid
    }
    
    func changeName(name: String) {
        print("Change Name")
    }
    
    func changePassword(newPassword: String) {
        print("Change Password")
    }
    
    func changePrivacy() {
        print("Change Privacy")
    }
    
    func setStatus() {
        print("Update status")
    }
    
    init(uid:String, username: String, email: String,  location: Location) {
        self.uid = uid
        self.username = username
        self.email = email
        self.role = K.Roles.roleUser
        self.loc = location
        self.status = K.StatusUser.safe
        super.init(lat: loc.lat, lon: loc.lon)
    }
}
