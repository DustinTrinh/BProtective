//
//  BondUserViewController.swift
//  BProtective
//
//  Created by Dustin Trinh on 2020-09-20.
//  Copyright © 2020 DustyTheCutie. All rights reserved.
//

import UIKit
import Firebase
import MaterialComponents
    
class BondUserViewController: UIViewController {
    let db = Firestore.firestore()
    var userReference: CollectionReference!
    var bondList: [BondInitiate] = []
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var createBond: UILabel!
    @IBOutlet weak var linkBond: UILabel!
    //@IBOutlet weak var bondNowButton: UIButton!
    @IBOutlet weak var errorMsg: UILabel!
    //@IBOutlet weak var codeInputBox: UITextField!
    @IBOutlet weak var bondNowButton: MDCFloatingButton!
    @IBOutlet weak var codeInputBox: MDCFilledTextField!
    @IBAction func initiateBond(_ sender: MDCFloatingButton) {
        errorMsg.text = ""
        descriptionLabel.text = "Ask your bond to enter the following code. \nThis code will expire in 24 hours"
        descriptionLabel.isHidden = false
        codeInputBox.isHidden = true
        bondNowButton.isHidden = true
        //Function to set code
        codeLabel.text = generateCode()
        codeLabel.isHidden = false
        
        //Push code and username to BondInitiate Database
        if let code = self.codeLabel.text, let email = Auth.auth().currentUser?.email{
            self.db.collection(K.Databases.InitiateBond.databaseName).addDocument(data: [
                K.Databases.InitiateBond.username: email,
                K.Databases.InitiateBond.code : code,
                K.Databases.InitiateBond.date : Date().timeIntervalSince1970
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
    
    @IBAction func linkBond(_ sender: UIButton) {
        errorMsg.text = ""
        descriptionLabel.isHidden = false
        descriptionLabel.text = "Enter the bond code you were provided"
        codeLabel.isHidden = true
        codeInputBox.isHidden = false
        bondNowButton.isHidden = false
    }
    
    @IBAction func bondAction(_ sender: UIButton) {
        var check:Bool = false
        var message = ""
        
        if let input = codeInputBox.text, let email = Auth.auth().currentUser?.email {
            for item in bondList{
                let comp: Bool = compareTime(prev: item.date, now: Date().timeIntervalSince1970)
                if item.code == input && item.username != email && comp != true{
                
                    //save Data onto SELF
                    let selfDict = [K.Databases.BondList.username : item.username, "Privacy" : "1", "Foreign_Privacy" : "1" ]
                    appendDataSelf(dataList: selfDict)
                    
                    //save Data onto OTHER
                    let otherDict = [K.Databases.InitiateBond.username: email, K.Databases.BondList.privacy: "1", "Foreign_Privacy" : "1"]
                    appendDataOther(dataList: otherDict, username: item.username)
            
                    errorMsg.textColor = UIColor.green
                    message = K.Messages.successfullyBond
                    check = true
                    break
                }
                else if item.code == input && item.username != email && comp == true {
                    errorMsg.textColor = UIColor.red
                    message = K.Messages.overtime
                    check = false
                    break
                }
                else if item.username == email {
                    errorMsg.textColor = UIColor.red
                    message = K.Messages.bondSelf
                    check = false
                }
                else{
                    errorMsg.textColor = UIColor.red
                    check = false
                }
            }
            errorMsg.text = message
            errorMsg.isHidden = false
            print("Final Check \(check)")
            codeInputBox.text = ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dat = ["Username" : "", "Privacy" : "", "Foreign_Privacy" : "" ]
        removeBlankBond(data: dat)
        // Do any additional setup after loading the view.
        title = K.Titles.bondUserTitle
        descriptionLabel.isHidden = true
        codeLabel.isHidden = true
        codeInputBox.isHidden = true
        bondNowButton.isHidden = true
        errorMsg.isHidden = true
        getList()
        
        let colorScheme = ApplicationScheme.shared.colorScheme
        self.view.tintColor = colorScheme.onSurfaceColor
        self.view.backgroundColor = colorScheme.surfaceColor
        
        self.createBond.textColor = colorScheme.onSecondaryColor
        self.linkBond.textColor = colorScheme.onSecondaryColor
        self.descriptionLabel.textColor = colorScheme.onSurfaceColor
        self.codeLabel.textColor = colorScheme.primaryColor
        self.aboutLabel.textColor = colorScheme.primaryColor
        self.errorMsg.textColor = colorScheme.errorColor
        
        codeInputBox.label.text = "Bond Code"
        codeInputBox.sizeToFit()
        view.addSubview(codeInputBox)
        
        MDCButtonColorThemer.applySemanticColorScheme(colorScheme, to: self.bondNowButton)
    }

    func compareTime(prev: Double, now: Double) -> Bool{
        let oneDay: Double = (60*60*24)
        let check: Double = now - prev
        
        if (check / oneDay) >= 1{
            return true
        }
        else{
            return false
        }
    }
    
    func getList(){
        db.collection("InitiateBond")
            .addSnapshotListener
            { (querySnapshot, error) in
            
            self.bondList = []
            if let e = error{
                print("Issue getting data: \(e)")
            }
            else{
                if let snapshotDoc = querySnapshot?.documents{
                    for doc in snapshotDoc{
                        let data = doc.data()
                        if let username = data["Username"] as? String, let code = data["Code"] as? String, let date = data["Date"] as? Double{
                            let bondy = BondInitiate(username: username, code: code, date: date)
                            self.bondList.append(bondy)
                        }
                    }
                    print("Done")
                    //print(self.bondList)
                }
            }
        }
    }
    
    func generateCode() -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<7).map{ _ in letters.randomElement()! })
    }
    
    func appendDataSelf(dataList: [String:String]) {
        userReference = db.collection(K.Databases.BondList.databaseName)
       
        if let username = Auth.auth().currentUser?.email{
           
            userReference.whereField(K.Databases.BondList.username, isEqualTo: username)
                .getDocuments() { [self] (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err.localizedDescription)")
                    }
                    else {
                        for document in querySnapshot!.documents {
                            
                            _ = document.data()
                            let docID = document.documentID
                            let ref = userReference.document(docID)
                            
                            ref.updateData(["bonds": FieldValue.arrayUnion([dataList] as [Any])
                            ]){ err in
                                if let err = err {
                                    print("Error updating document: \(err)")
                                } else {
                                    print("Document successfully appended")
                                }
                            }
                        }
                    }
            }
        }
    }
    
    func appendDataOther(dataList: [String:String], username: String) {
        userReference = db.collection(K.Databases.BondList.databaseName)
       
        if (Auth.auth().currentUser?.email) != nil{
           
            userReference.whereField(K.Databases.BondList.username, isEqualTo: username)
                .getDocuments() { [self] (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err.localizedDescription)")
                    }
                    else {
                        for document in querySnapshot!.documents {
                            
                            _ = document.data()
                            let docID = document.documentID
                            let ref = userReference.document(docID)
                            
                            ref.updateData(["bonds": FieldValue.arrayUnion([dataList] as [Any])
                            ]){ err in
                                if let err = err {
                                    print("Error updating document: \(err)")
                                } else {
                                    print("Document successfully appended")
                                }
                            }
                        }
                    }
            }
        }
    }
    
    func removeBlankBond(data: [String: String]) {
        userReference = db.collection(K.Databases.BondList.databaseName)
       
        if let username = Auth.auth().currentUser?.email{
           
            userReference.whereField(K.Databases.BondList.username, isEqualTo: username)
                .getDocuments() { [self] (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err.localizedDescription)")
                    }
                    else {
                        for document in querySnapshot!.documents {
                            _ = document.data()
                            let docID = document.documentID
                            let ref = userReference.document(docID)
                            
                            ref.updateData(["bonds": FieldValue.arrayRemove([data] as [Any])
                            ]){ err in
                                if let err = err {
                                    print("Error updating document: \(err)")
                                } else {
                                    print("Document successfully appended")
                                }
                            }
                        }
                    }
            }
        }
    }
}


