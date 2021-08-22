//
//  ChangePasswordViewController.swift
//  BProtective
//
//  Created by Dustin Trinh on 2020-10-11.
//  Copyright © 2020 DustyTheCutie. All rights reserved.
//

import UIKit
import Firebase
import MaterialComponents

class ChangePasswordViewController: UIViewController {
    let db = Firestore.firestore()
    var userReference: CollectionReference!
    
    @IBOutlet weak var oldPasswordInput: MDCFilledTextField!
    //@IBOutlet weak var oldPasswordInput: UITextField!
    @IBOutlet weak var newPasswordInput: MDCFilledTextField!
    //@IBOutlet weak var newPasswordInput: UITextField!
    @IBOutlet weak var retypePasswordInput: MDCFilledTextField!
    //@IBOutlet weak var retypePasswordInput: UITextField!
    @IBOutlet weak var messages: UILabel!
    @IBOutlet weak var changeButton: MDCFloatingButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func changeButtonPressed(_ sender: MDCFloatingButton) {
        activityIndicator.startAnimating()
        self.messages.text = ""


        if (oldPasswordInput.text == "" || newPasswordInput.text == "" || retypePasswordInput.text == "")
        {
            self.messages.text = "All fields must be populated"
            self.messages.isHidden = false
            self.messages.textColor = UIColor.red
            self.activityIndicator.stopAnimating()
        }
        
        else if oldPasswordInput.text == newPasswordInput.text
        {
            self.messages.text = "New password cannot be the same as old password"
            self.messages.isHidden = false
            self.messages.textColor = UIColor.red
            self.activityIndicator.stopAnimating()
        }
        
        
        else if newPasswordInput.text == retypePasswordInput.text{
            let email = (Auth.auth().currentUser?.email)!
            let currentPassword = oldPasswordInput.text!
            let newPassword = retypePasswordInput.text!
            let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
                   Auth.auth().currentUser?.reauthenticate(with: credential, completion: { (result, error) in
                       if let e = error {
                        self.messages.isHidden = false
                        self.messages.textColor = UIColor.red
                        self.messages.text = e.localizedDescription
                        self.activityIndicator.stopAnimating()
                       }
                       else {
                           Auth.auth().currentUser?.updatePassword(to: newPassword, completion: { (error) in
                            if let e = error{
                                self.messages.isHidden = false
                                self.messages.textColor = UIColor.red
                                self.messages.text = e.localizedDescription
                                self.activityIndicator.stopAnimating()
                            }
                            else{
                                self.messages.isHidden = false
                                self.messages.textColor = UIColor.green
                                self.messages.text = K.Messages.changedPasswordSuccessfully
                                print("Changed Password.")
                                self.activityIndicator.stopAnimating()
                                self.oldPasswordInput.text = ""
                                self.newPasswordInput.text = ""
                                self.retypePasswordInput.text = ""
                            }
                           })
                       }
                   })
        }
        else{
            messages.isHidden = false
            messages.text = K.Messages.reauthenticateError
            activityIndicator.stopAnimating()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = K.Titles.changePassword
        messages.isHidden = true
        
        let colorScheme = ApplicationScheme.shared.colorScheme
        self.view.tintColor = colorScheme.onSurfaceColor
        self.view.backgroundColor = colorScheme.surfaceColor
        self.messages.textColor = colorScheme.errorColor
        self.activityIndicator.hidesWhenStopped = true

        oldPasswordInput.label.text = "Old Password"
        oldPasswordInput.sizeToFit()
        view.addSubview(oldPasswordInput)
        
        newPasswordInput.label.text = "New Password"
        newPasswordInput.sizeToFit()
        view.addSubview(newPasswordInput)
        
        retypePasswordInput.label.text = "Retype New Password"
        retypePasswordInput.sizeToFit()
        view.addSubview(retypePasswordInput)
        
        MDCButtonColorThemer.applySemanticColorScheme(colorScheme,to: self.changeButton)
    }
    


}
