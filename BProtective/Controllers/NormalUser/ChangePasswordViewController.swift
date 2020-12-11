//
//  ChangePasswordViewController.swift
//  BProtective
//
//  Created by Dustin Trinh on 2020-10-11.
//  Copyright © 2020 DustyTheCutie. All rights reserved.
//

import UIKit
import Firebase

class ChangePasswordViewController: UIViewController {
    let db = Firestore.firestore()
    var userReference: CollectionReference!
    
    @IBOutlet weak var oldPasswordInput: UITextField!
    @IBOutlet weak var newPasswordInput: UITextField!
    @IBOutlet weak var retypePasswordInput: UITextField!
    @IBOutlet weak var messages: UILabel!
    
    @IBAction func changeButtonPressed(_ sender: UIButton) {
        if newPasswordInput.text == retypePasswordInput.text{
            let email = (Auth.auth().currentUser?.email)!
            let currentPassword = oldPasswordInput.text!
            let newPassword = retypePasswordInput.text!
            let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
                   Auth.auth().currentUser?.reauthenticate(with: credential, completion: { (result, error) in
                       if let e = error {
                        self.messages.isHidden = false
                        self.messages.textColor = UIColor.red
                        self.messages.text = e.localizedDescription
                       }
                       else {
                           Auth.auth().currentUser?.updatePassword(to: newPassword, completion: { (error) in
                            if let e = error{
                                self.messages.isHidden = false
                                self.messages.textColor = UIColor.red
                                self.messages.text = e.localizedDescription
                            }
                            else{
                                self.messages.isHidden = false
                                self.messages.textColor = UIColor.green
                                self.messages.text = K.Messages.changedPasswordSuccessfully
                                print("Changed Password.")
                            }
                           })
                       }
                   })
        }
        else{
            messages.isHidden = false
            messages.text = K.Messages.reauthenticateError
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = K.Titles.changePassword
        messages.isHidden = true
    }
    


}
