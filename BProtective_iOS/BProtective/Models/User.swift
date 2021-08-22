//
//  User.swift
//  BProtective
//
//  Created by Dustin Trinh on 2020-09-08.
//  Copyright © 2020 DustyTheCutie. All rights reserved.
//

import UIKit

protocol User {
    var uid: String{get set}
    var username: String{get set}
    var email: String {get set}
    var role: String {get set}
    
    func changeName(name: String)
    func changePassword(newPassword: String)
    func changePrivacy()

}
