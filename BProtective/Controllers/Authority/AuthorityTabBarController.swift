//
//  AuthorityTabBarController.swift
//  BProtective
//
//  Created by Dustin Trinh on 2020-09-25.
//  Copyright © 2020 DustyTheCutie. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class AuthorityTabBarController: UITabBarController {

    @IBAction func logout(_ sender: UIButton) {
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
