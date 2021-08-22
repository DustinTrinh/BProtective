//
//  ChangePasswordAuthorityViewController.swift
//  BProtective
//
//  Created by Dustin Trinh on 2020-11-29.
//  Copyright © 2020 DustyTheCutie. All rights reserved.
//


import UIKit
import Firebase
import MaterialComponents

class ChangePasswordAuthorityViewController: UIViewController {
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var oldPassInput: MDCFilledTextField!
   // @IBOutlet weak var oldPassInput: UITextField!
    @IBOutlet weak var newPassInput: MDCFilledTextField!
    //@IBOutlet weak var retypeNewPass: UITextField!
    @IBOutlet weak var retypeNewPass: MDCFilledTextField!
    //@IBOutlet weak var newPassInput: UITextField!
    @IBOutlet weak var changeButton: MDCFloatingButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBAction func changePasswordPressed(_ sender: MDCFloatingButton) {
        activityIndicator.startAnimating()

        self.message.text = ""

        if (oldPassInput.text == "" || newPassInput.text == "")
        {
            self.message.text = "All fields must be populated"
            self.message.isHidden = false
            self.message.textColor = UIColor.red
            self.activityIndicator.stopAnimating()
        }
        
        else if oldPassInput.text == newPassInput.text
        {
            self.message.text = "New password cannot be the same as old password"
            self.message.isHidden = false
            self.message.textColor = UIColor.red
            self.activityIndicator.stopAnimating()
        }
        
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
                        self.activityIndicator.stopAnimating()
                       }
                       else {
                           Auth.auth().currentUser?.updatePassword(to: newPassword, completion: { (error) in
                            if let e = error{
                                self.message.isHidden = false
                                self.message.textColor = UIColor.red
                                self.message.text = e.localizedDescription
                                self.activityIndicator.stopAnimating()
                            }
                            else{
                                self.message.isHidden = false
                                self.message.textColor = UIColor.green
                                self.message.text = K.Messages.changedPasswordSuccessfully
                                print("Changed Password.")
                                self.activityIndicator.stopAnimating()
                            }
                           })
                       }
                   })
        }
        else{
            message.isHidden = false
            message.text = K.Messages.reauthenticateError
            self.activityIndicator.stopAnimating()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let colorScheme = ApplicationScheme.shared.colorScheme
        self.view.tintColor = colorScheme.onSurfaceColor
        self.view.backgroundColor = colorScheme.surfaceColor
        self.activityIndicator.hidesWhenStopped = true

        oldPassInput.label.text = "Old Password"
        oldPassInput.sizeToFit()
        view.addSubview(oldPassInput)
        
        newPassInput.label.text = "New Password"
        newPassInput.sizeToFit()
        view.addSubview(newPassInput)
        
        retypeNewPass.label.text = "Retype New Password"
        retypeNewPass.sizeToFit()
        view.addSubview(retypeNewPass)
        
        MDCButtonColorThemer.applySemanticColorScheme(colorScheme,to: self.changeButton)
    }
}
