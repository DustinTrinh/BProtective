//
//  Authority.swift
//  BProtective
//
//  Created by Dustin Trinh on 2020-10-02.
//  Copyright © 2020 DustyTheCutie. All rights reserved.
//

import UIKit

class Authority: Location, User{
    
    var uid:String
    var username: String
    var email: String
    var role: String
    var status: String
    var loc: Location
    
    func changeName(name: String) {
        print("Change Username")
    }
    
    func changePassword(newPassword: String) {
        print("Change Password")
    }
    
    func changePrivacy() {
        print("Change Privacy")
    }
    
    init(uid: String,username: String, email: String, location: Location) {
        
        self.uid = uid
        self.username = username
        self.email = email
        self.role = K.Roles.roleAuthority
        self.status = K.StatusAuthority.online
        self.loc = location
        super.init(lat: loc.lat, lon: loc.lon)
    }

}
