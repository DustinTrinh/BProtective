//
//  LoginViewController.swift
//  BProtective
//
//  Created by Dustin Trinh on 2020-09-04.
//  Copyright © 2020 DustyTheCutie. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class LoginViewController: UIViewController {
    let db = Firestore.firestore()
    var userReference1: CollectionReference!
    var userReference2: CollectionReference!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var errorMsg: UILabel!
    @IBAction func loginPressed(_ sender: UIButton) {
        
        if let email = usernameTextField.text, let password = passwordTextField.text{
            Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                if let e = error{
                    self.errorMsg.isHidden = false
                    self.errorMsg.text = e.localizedDescription
                }
                else{
                    
                    self.userReference1 = self.db.collection(K.Databases.NormalUser.databaseName)
                   
                    if let uid = Auth.auth().currentUser?.uid{
                        //print("This is my UID: \(uid)")
                        self.userReference1.whereField("UID", isEqualTo: uid)
                            .getDocuments() { [self] (querySnapshot, err) in
                                if let err = err {
                                    print("Error getting documents: \(err.localizedDescription)")
                                } else {
                                    for document in querySnapshot!.documents {
                                        
                                        let saveData = document.data()
                                       
                                        if(saveData["Role"] as! String == "User" && (saveData["Banned"] != nil) == false){
                                            self.performSegue(withIdentifier: K.Segue.loginToMainSegue, sender: self)
                                        }
                                    }
                                }
                        }
                    }
                    
                    self.userReference2 = self.db.collection(K.Databases.Authority.databaseName)
                    if let uid = Auth.auth().currentUser?.uid{
                        self.userReference2.whereField("UID", isEqualTo: uid)
                            .getDocuments() { [self] (querySnapshot, err) in
                                if let err = err {
                                    print("Error getting documents: \(err.localizedDescription)")
                                } else {
                                    for document in querySnapshot!.documents {
                                        
                                        let saveData = document.data()
                                       
                                        if(saveData["Role"] as! String == "Authority" && (saveData["Banned"] != nil) == false){
                                            self.performSegue(withIdentifier: K.Segue.loginToMainAuthoritySegue, sender: self)
                                        }
                                    }
                                }
                        }
                    }
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        errorMsg.isHidden = true
        // Do any additional setup after loading the view.
    }


}





