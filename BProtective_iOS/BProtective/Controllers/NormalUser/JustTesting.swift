//
//  JustTesting.swift
//  BProtective
//
//  Created by Dustin Trinh on 2020-10-11.
//  Copyright © 2020 DustyTheCutie. All rights reserved.
//

import UIKit
import Firebase

class JustTesting: UIViewController {
    let db = Firestore.firestore()
    var userReference: CollectionReference!
    var bonds: [Dictionary<String,String>] = []
    var items2: [Dictionary<String,String>] = []
    var testAppend = ["Username" : "test4" , "Privacy" : "1"]
    
    @IBAction func removeBond(_ sender: Any) {
        let dat = ["Username" : "", "Privacy" : "" ]
        removeData(data: dat)
    }
    @IBAction func getData_1(_ sender: Any) {
        getData_1()
    }
    @IBAction func addData(_ sender: UIButton) {
        var items: [Dictionary<String,String>] = []
        let dict1 = ["Username" : "test1", "Privacy" : "1" ]
        let dict2 = ["Username" : "test2", "Privacy" : "3"]
        let dict3 = ["Username" : "test3" , "Privacy" : "2"]
        
        items.append(dict1)
        items.append(dict2)
        items.append(dict3)
        
        addBonds(arr: items)
    }
    @IBAction func append(_ sender: UIButton) {
        let testing = ["Username": "test19", "Privacy": "1"]
        appendData(dataList: testing)
    }
    @IBAction func getData(_ sender: Any) {
        getData()
    }
    @IBAction func getEmergencyPressed(_ sender: Any) {
        getEmergency()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        items2.append(testAppend)
        
    }
     
    //Use to add blank bonds when create new users
    func addBonds(arr: [Dictionary<String,String>]) {
        if let email = Auth.auth().currentUser?.email{
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
    }
    
    func getData() {
        userReference = db.collection(K.Databases.BondList.databaseName)
       
        if let username = Auth.auth().currentUser?.email{
           
            userReference.whereField(K.Databases.BondList.username, isEqualTo: username)
                .getDocuments() { [self] (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err.localizedDescription)")
                    } else {
                        for document in querySnapshot!.documents {
                            
                            let saveData = document.data()
                            let docID = document.documentID
                            print("saveData: \(saveData)")
                            print("docID: \(docID)")
                            
                            print("saveData explain: \(saveData["bonds"]!)")
                            let saveData1 = saveData["bonds"]! as! [[String: Any]]
                            
                            for data in saveData1 {
                                print("Username Bonds: \(String(describing: data["Username"]))")
                                print("Privacy Bonds: \(data["Privacy"] ?? "")")
                            }
                        }
                    }
            }
        }
    }
    
    func appendData(dataList: [String:String]) {
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
    
    func removeData(data: [String: String]) {
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
    
    func appendDataForeign(dataList: [String:String]){
        userReference = db.collection(K.Databases.BondList.databaseName)
        
        let foreignUsername = dataList["Username"]!
        if let username = Auth.auth().currentUser?.email{
            
            let foreignArray = ["Username": username , "Privacy": dataList["Privacy"]!]
            userReference.whereField(K.Databases.BondList.username, isEqualTo: foreignUsername)
                .getDocuments() { [self] (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err.localizedDescription)")
                    }
                    else {
                        for document in querySnapshot!.documents {
                            
                            _ = document.data()
                            let docID = document.documentID
                            let ref = userReference.document(docID)
                            
                            ref.updateData(["bonds": FieldValue.arrayUnion([foreignArray] as [Any])
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
    
    func getData_1() {
        userReference = db.collection(K.Databases.BondList.databaseName)
       
        if let username = Auth.auth().currentUser?.email{
           
            userReference.whereField(K.Databases.BondList.username, isEqualTo: username)
                .getDocuments() { [self] (querySnapshot, err) in
                    bonds = []
                    if let err = err {
                        print("Error getting documents: \(err.localizedDescription)")
                    } else {
                        for document in querySnapshot!.documents {
                            
                            let saveData = document.data()
                            let saveData1 = saveData["bonds"]!
                            bonds = saveData1 as! [Dictionary<String, String>]
                            
                            for bond in bonds{
                                print("TEST TEST TEST GET DATA 1: \(bond["Username"]!) \(bond["Privacy"]!)")
                            }
                        }
                    }
            }
        }
    }
    
    func getEmergency(){
        userReference = db.collection(K.Databases.NormalUser.databaseName)
        
        var usernames: [String] = []
        var latitude: [Double] = []
        var longitude: [Double] = []
        
        if (Auth.auth().currentUser?.email) != nil{
           
            userReference.whereField(K.Databases.NormalUser.status, isEqualTo: K.StatusUser.emergency)
                .getDocuments() { [self] (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err.localizedDescription)")
                    } else {
                        for document in querySnapshot!.documents {
                            
                            let saveData = document.data()
                            _ = document.documentID
                            
                            usernames.append(saveData[K.Databases.NormalUser.email]! as! String)
                            latitude.append(saveData[K.Databases.NormalUser.lat]! as! Double)
                            longitude.append(saveData[K.Databases.NormalUser.lon]! as! Double)
                            
                            
                            print("INSIDE Username: \(usernames) \n Longitude: \(longitude) \n Latitude \(latitude)")
                        }
                    }
            }
        }    
    }

}
