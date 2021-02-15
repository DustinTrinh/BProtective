//
//  ChangePasswordAuthorityViewController.swift
//  BProtective
//
//  Created by Dustin Trinh on 2020-11-29.
//  Copyright © 2020 DustyTheCutie. All rights reserved.
//


import UIKit
import Firebase

class ChangePasswordAuthorityViewController: UIViewController {
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var oldPassInput: UITextField!
    @IBOutlet weak var retypeNewPass: UITextField!
    @IBOutlet weak var newPassInput: UITextField!
    @IBAction func changePasswordPressed(_ sender: Any) {
        if newPassInput.text == retypeNewPass.text{
        
            let email = (Auth.auth().currentUser?.email)!
            let currentPassword = oldPassInput.text!
            let newPassword = retypeNewPass.text!
            let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
                   Auth.auth().currentUser?.reauthenticate(with: credential, completion: { (result, error) in
                       if let e = error {
                        self.message.isHidden = false
                        self.message.textColor = UIColor.red
                        self.message.text = e.localizedDescription
                       }
                       else {
                           Auth.auth().currentUser?.updatePassword(to: newPassword, completion: { (error) in
                            if let e = error{
                                self.message.isHidden = false
                                self.message.textColor = UIColor.red
                                self.message.text = e.localizedDescription
                            }
                            else{
                                self.message.isHidden = false
                                self.message.textColor = UIColor.green
                                self.message.text = K.Messages.changedPasswordSuccessfully
                                print("Changed Password.")
                            }
                           })
                       }
                   })
        }
        else{
            message.isHidden = false
            message.text = K.Messages.reauthenticateError
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}
