//
//  SettingsViewController.swift
//  BProtective
//
//  Created by Dustin Trinh on 2020-09-20.
//  Copyright © 2020 DustyTheCutie. All rights reserved.
//

import UIKit
import Firebase
import MaterialComponents

class SettingsViewController: UIViewController {
    let db = Firestore.firestore()
    var userReference: CollectionReference!
    
    @IBOutlet weak var chgPasswordBtn: MDCFloatingButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = K.Titles.settingsTitle
        
        let colorScheme = ApplicationScheme.shared.colorScheme
        self.view.tintColor = colorScheme.onSurfaceColor
        self.view.backgroundColor = colorScheme.surfaceColor
        
        MDCButtonColorThemer.applySemanticColorScheme(colorScheme,to: self.chgPasswordBtn)
    }
    


}
