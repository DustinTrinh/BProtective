//
//  ViewController.swift
//  BProtective
//
//  Created by Dustin Trinh on 2020-09-04.
//  Copyright © 2020 DustyTheCutie. All rights reserved.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {
    let db = Firestore.firestore()
    var userReference1: CollectionReference!
    var userReference2: CollectionReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if Auth.auth().currentUser != nil{
            
            userReference1 = db.collection(K.Databases.NormalUser.databaseName)
            
            if let uid = Auth.auth().currentUser?.uid{
                print("This is my UID: \(uid)")
                userReference1.whereField("UID", isEqualTo: uid)
                    .getDocuments() { [self] (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err.localizedDescription)")
                        } else {
                            for document in querySnapshot!.documents {
                                
                                let saveData = document.data()
                                print("saveData: \(saveData)")
                                
                                if(saveData["Role"] as! String == K.Roles.roleUser){
                                    self.performSegue(withIdentifier: K.Segue.loggedInSegue, sender: self)
                                    print("LOGGED IN")
                                }
                            }
                        }
                }
            }
            
            userReference2 = db.collection(K.Databases.Authority.databaseName)
            if let uid = Auth.auth().currentUser?.uid{
                print("This is my UID: \(uid)")
                userReference2.whereField("UID", isEqualTo: uid)
                    .getDocuments() { [self] (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err.localizedDescription)")
                        } else {
                            for document in querySnapshot!.documents {
                                
                                let saveData = document.data()
                                print("saveData: \(saveData)")
                                
                                if(saveData["Role"] as! String == K.Roles.roleAuthority){
                                    self.performSegue(withIdentifier: K.Segue.loggedInAuthoritySegue, sender: self)
                                    print("LOGGED IN")
                                }
                            }
                        }
                }
            }

            
        }
        else{
            print("NOT LOG IN")
        }
    }


}



