//
//  UniversalTabBarController.swift
//  BProtective
//
//  Created by Dustin Trinh on 2020-09-04.
//  Copyright © 2020 DustyTheCutie. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class UniversalTabBarController: UITabBarController {
    let db = Firestore.firestore()
    var userReference: CollectionReference!
    var saveData: [String: Any] = [:]
    var user:NormalUser!
    var saveUser: NormalUser?
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            self.navigationController?.popToRootViewController(animated: true)
        }
        catch let signOutError as NSError{
                print("Error Signning out: %@", signOutError)
            }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.hidesBackButton = true
        
    }
}
