//
//  Constant.swift
//  BProtective
//
//  Created by Dustin Trinh on 2020-09-04.
//  Copyright © 2020 DustyTheCutie. All rights reserved.
//

import UIKit

struct K {
    
    struct Table{
        static let cellIdentifier = "bondListCellReuse"
        static let emergencyList = "emergencyNames"
    }
    
    struct Segue{
        static let loginSegue = "LoginSegue"
        static let signupSegue = "SignUpSegue"
        static let signupToMainSegue = "SignupToMainSegue"
        static let loginToMainSegue = "LoginToMainSegue"
        static let loggedInSegue = "AlreadyLoggedIn"
        static let loginToMainAuthoritySegue = "LoginToMainSegueAuthority"
        static let loggedInAuthoritySegue = "AlreadyLoggedInAuthority"
        static let changePasswordSegue = "changePasswordSegue"
        static let changePasswordAuthorSegue = "AuthorPasswordChangeSegue"
        static let towardEmergencyPathSegue = "TowardEmergencyPath"
    }
    
    struct Titles{
        static let bondUserTitle = "Bond Users"
        static let bondListTitle = "List of Bonds"
        static let chatBondTitle = "Chatbox"
        static let privacyBondTitle = "Privacy with Bond"
        static let settingsTitle = "Settings"
        static let changePassword = "Change Password"
        static let alarmList = "Alarm List"
        static let emergencyPath = "Emergency Path"
    }
    
    struct Roles{
        static let roleUser = "User"
        static let roleAdmin = "Admin"
        static let roleAuthority = "Authority"
    }
    
    struct Databases{
        
        struct NormalUser {
            static let databaseName = "NormalUser"
            static let email = "Email"
            static let lat = "LocationLatitude"
            static let lon = "LocationLongitude"
            static let role = "Role"
            static let status = "Status"
            static let UID = "UID"
            static let username = "Username"
        }
        
        struct Authority {
            static let databaseName = "Authority"
            static let email = "Email"
            static let lat = "LocationLatitude"
            static let lon = "LocationLongitude"
            static let role = "Role"
            static let status = "Status"
            static let UID = "UID"
            static let username = "Username"
        }
        
        struct InitiateBond{
            static let databaseName = "InitiateBond"
            static let username = "Username"
            static let code = "Code"
            static let date = "Date"
        }
        
        struct Alarms{
            static let databaseName = "Alarms"
            static let username = "Username"
            static let lat = "Latitude"
            static let lon = "Longitude"
            static let date = "Date"
            static let status = "Status"
        }
        
        struct BondList {
            static let databaseName = "BondList"
            static let username = "Username"
            static let bonds = "bonds"
            static let privacy = "Privacy"
        }
    }
    
    struct StatusUser{
        static let safe = "safe"
        static let unsafe = "unsafe"
        static let emergency = "emergency"
    }
    
    struct StatusAuthority{
        static let online = "online"
        static let offline = "offline"
    }
    
    struct Messages{
        static let reauthenticateError = "New password and retype password do not match."
        static let changedPasswordSuccessfully = "You successfully Changed your password. Please re-login"
        static let successfullyBond = "Successfully Bonded"
        static let overtime = "Your code is expired"
        static let bondSelf = "You cannot bond with yourself"
    }
    


}
