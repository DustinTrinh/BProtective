//
//  SettingsViewController.swift
//  BProtective
//
//  Created by Dustin Trinh on 2020-09-20.
//  Copyright © 2020 DustyTheCutie. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {
    let db = Firestore.firestore()
    var userReference: CollectionReference!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = K.Titles.settingsTitle
    }
    


}
