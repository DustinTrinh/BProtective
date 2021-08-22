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
import MaterialComponents

class LoginViewController: UIViewController {
    let db = Firestore.firestore()
    var userReference1: CollectionReference!
    var userReference2: CollectionReference!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: MDCFloatingButton!
    @IBOutlet weak var usernameTextField: MDCFilledTextField!
    @IBOutlet weak var passwordTextField: MDCFilledTextField!
    
    @IBOutlet weak var errorMsg: UILabel!
    @IBAction func loginPressed(_ sender: MDCFloatingButton) {
        loadingIndicator.startAnimating()
        if let email = usernameTextField.text, let password = passwordTextField.text{
            Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                if let e = error{
                    self.errorMsg.isHidden = false
                    self.errorMsg.text = e.localizedDescription
                    self.loadingIndicator.stopAnimating()
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
                                        let _ : Bool? = saveData["Banned"] as? Bool
                                        print("Check saveData: \(saveData)")
                                        
                                        
                                        if(saveData["Role"] as! String == "User" && saveData["Banned"] as! Bool == false){
                                            print("Logged In Confirmed")
                                            self.performSegue(withIdentifier: K.Segue.loginToMainSegue, sender: self)
                                            self.loadingIndicator.stopAnimating()
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
                                        let _ : Bool? = saveData["Banned"] as? Bool
                                        if(saveData["Role"] as! String == "Authority"){
                                            self.performSegue(withIdentifier: K.Segue.loginToMainAuthoritySegue, sender: self)
                                            self.loadingIndicator.stopAnimating()
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
        let colorScheme = ApplicationScheme.shared.colorScheme
        self.view.tintColor = colorScheme.onSurfaceColor
        self.view.backgroundColor = colorScheme.surfaceColor
        self.errorMsg.textColor = colorScheme.errorColor
        self.loadingIndicator.hidesWhenStopped = true

        
        usernameTextField.label.text = "Email"
        usernameTextField.sizeToFit()
        view.addSubview(usernameTextField)
        
        passwordTextField.label.text = "Password"
        passwordTextField.sizeToFit()
        view.addSubview(passwordTextField)
        
        MDCButtonColorThemer.applySemanticColorScheme(colorScheme,to: self.loginButton)
    }


}





