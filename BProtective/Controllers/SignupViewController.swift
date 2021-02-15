//
//  SignupViewController.swift
//  BProtective
//
//  Created by Dustin Trinh on 2020-09-04.
//  Copyright © 2020 DustyTheCutie. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController: UIViewController {
    let db = Firestore.firestore()
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errrorMsg: UILabel!
    @IBAction func signupPressed(_ sender: UIButton) {
        if let email = usernameTextField.text, let password = passwordTextField.text{
            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                if let e = error{
                    self.errrorMsg.isHidden = false
                    self.errrorMsg.text = e.localizedDescription
                    print("Username: \(email)")
                    print("Password: \(password)")
                }
                else{
                    //Sign up and Store new User into datanase (skeleton)
                    
                    if let username = self.usernameTextField.text{
                        let storeLoc = Location(lat: 0.0, lon: 0.0)
                        let storeUser = NormalUser(uid: Auth.auth().currentUser?.uid ?? "No UID",username: username, email: username, location: storeLoc)
                        //Add data into database of NORMALUSER
                        self.db.collection(K.Databases.NormalUser.databaseName).addDocument(data: [
                            K.Databases.NormalUser.UID: storeUser.uid,
                            K.Databases.NormalUser.username: storeUser.username,
                            K.Databases.NormalUser.email: storeUser.email,
                            K.Databases.NormalUser.status: K.StatusUser.safe,
                            K.Databases.NormalUser.role: K.Roles.roleUser,
                            K.Databases.NormalUser.lat: storeUser.loc.lat,
                            K.Databases.NormalUser.lon: storeUser.loc.lon,
                            K.Databases.NormalUser.banned: false
                        ]) { (error) in
                            if let e = error{
                                print("Issue saving data into firestore: \(e)")
                            }
                            else{
                                print("Successfully Signed Up User")
                            }
                        }
                        
                        //Create blank template for BONDLIST
                        var empty : [Dictionary<String,String>] = []
                        let emp = ["Username" : "", "Privacy" : "", "Foreign_Privacy" : ""]
                        empty.append(emp)
                        self.bondListTemplate(arr: empty, username: storeUser.email)
                    }
 
                    self.performSegue(withIdentifier: K.Segue.signupToMainSegue, sender: self)
                }
            }
            
        }
    }
    
    func bondListTemplate(arr: [Dictionary<String,String>], username: String) {
        if let email = Auth.auth().currentUser?.email {
            self.db.collection(K.Databases.BondList.databaseName).addDocument(data: [
                K.Databases.BondList.username: email,
                K.Databases.BondList.bonds: arr
            ]) { (error) in
                if let e = error{
                    print("Issue saving data into firestore: \(e)")
                }
                else{
                    print("Successfully save data")
                }
            }
        }
        else{
            self.db.collection(K.Databases.BondList.databaseName).addDocument(data: [
                K.Databases.BondList.username: username,
                K.Databases.BondList.bonds: arr
            ]) { (error) in
                if let e = error{
                    print("Issue saving data into firestore: \(e)")
                }
                else{
                    print("Successfully save data")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        errrorMsg.isHidden = true
    }


}
