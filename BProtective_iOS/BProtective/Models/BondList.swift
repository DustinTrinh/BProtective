//
//  BondList.swift
//  BProtective
//
//  Created by Dustin Trinh on 2020-10-02.
//  Copyright © 2020 DustyTheCutie. All rights reserved.
//

import UIKit

class BondList{
    var username: String
    var bonds: [Dictionary<String,String>]
    
    init(username: String, bonds: [Dictionary<String,String>]){
        self.username = username
        self.bonds = bonds
    }
}
