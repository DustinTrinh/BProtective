//
//  BondListViewController.swift
//  BProtective
//
//  Created by Dustin Trinh on 2020-09-20.
//  Copyright © 2020 DustyTheCutie. All rights reserved.
//

import UIKit
import Firebase

class BondListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    let db = Firestore.firestore()
    var userReference: CollectionReference!
    var bonds: [Dictionary<String,String>] = []
    var refresh = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = K.Titles.bondListTitle
        tableView.dataSource = self
        tableView.delegate = self
        refresh.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresh.addTarget(self, action: #selector(self.refreshTable(_:)), for: .valueChanged)
        tableView.addSubview(refresh)
        getData()
        
    }
    
    func getData() {
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
                            let saveData1 = saveData[K.Databases.BondList.bonds]!
                            bonds = saveData1 as! [Dictionary<String, String>]
                            
                            DispatchQueue.main.async {
                                
                                if(bonds.isEmpty){
                                    let emp = ["Empty":"No bonds available"]
                                    bonds.append(emp)
                                }
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.bonds.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                    }
            }
        }
    }
    
    func removeBondSelf(targetUsername: String){
        userReference = db.collection(K.Databases.BondList.databaseName)

        if let username = Auth.auth().currentUser?.email{
            userReference.whereField(K.Databases.BondList.username, isEqualTo: username)
                .getDocuments() { [self] (querySnapshot, err) in

                    if let err = err {
                        print("Error getting documents: \(err.localizedDescription)")
                    } else {
                        for document in querySnapshot!.documents {
                            
                            let saveData = document.data()
                            let saveData1 = saveData["bonds"] as! [Dictionary<String,String>]
                            
                            for item in saveData1 {
                                if(item[K.Databases.BondList.username] == targetUsername){
                                    let docID = document.documentID
                                    let ref = userReference.document(docID)
                                    
                                    let data = [K.Databases.BondList.username : item[K.Databases.BondList.username] ?? "" ,  K.Databases.BondList.privacy : item[K.Databases.BondList.privacy] ?? "",
                                        K.Databases.BondList.fprivacy : item[K.Databases.BondList.fprivacy] ?? ""]
                                    print("THis is data \(data)")
                                    ref.updateData([K.Databases.BondList.bonds: FieldValue.arrayRemove([data] as [Any])
                                    ]){ err in
                                        if let err = err {
                                            print("Error updating document: \(err)")
                                        } else {
                                            print("Document successfully appended")
                                        }
                                        print("Remove Self Bond triggered")
                                    }
                                }
                            }
                        }
                    }
            }
        }
    }
    
    func removeBondOther(targetUsername: String){
        userReference = db.collection(K.Databases.BondList.databaseName)

        if let username = Auth.auth().currentUser?.email{
            userReference.whereField(K.Databases.BondList.username, isEqualTo: targetUsername)
                .getDocuments() { [self] (querySnapshot, err) in

                    if let err = err {
                        print("Error getting documents: \(err.localizedDescription)")
                    } else {
                        for document in querySnapshot!.documents {
                            
                            let saveData = document.data()
                            let saveData1 = saveData["bonds"] as! [Dictionary<String,String>]
                            
                            for item in saveData1 {
                                if(item[K.Databases.BondList.username] == username){
                                    let docID = document.documentID
                                    let ref = userReference.document(docID)
                                    
                                    let data = [K.Databases.BondList.username : item[K.Databases.BondList.username] ?? "",  K.Databases.BondList.privacy : item[K.Databases.BondList.privacy] ?? "",
                                        K.Databases.BondList.fprivacy : item[K.Databases.BondList.fprivacy] ?? ""]
                                    print("THis is data \(data)")
                                    ref.updateData([K.Databases.BondList.bonds: FieldValue.arrayRemove([data] as [Any])
                                    ]){ err in
                                        if let err = err {
                                            print("Error updating document: \(err)")
                                        } else {
                                            print("Document successfully appended")
                                        }
                                    }
                                    
                                    print("Remove Other Bond triggered")
                                }
                            }
                        }
                    }
            }
        }
    }
    
    @objc func refreshTable(_ sender: AnyObject) {
       getData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bonds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let usr = bonds[indexPath.row][K.Databases.BondList.username]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Table.cellIdentifier, for: indexPath)
        cell.textLabel?.text = usr
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(bonds[indexPath.row]) clicked")
        let vc = storyboard?.instantiateViewController(identifier: "BondDisplayViewController") as? BondDisplayViewController
        vc?._username = bonds[indexPath.row][K.Databases.BondList.username] ?? ""
        vc?.privacy = bonds[indexPath.row][K.Databases.BondList.privacy] ?? ""
        vc?.fprivacy = bonds[indexPath.row][K.Databases.BondList.fprivacy] ?? ""
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let usr = bonds[indexPath.row][K.Databases.BondList.username]
        
        if editingStyle == .delete {
                bonds.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            
            //REMOVE BONDS FROM BOTH SIDE
            removeBondSelf(targetUsername: usr ?? "")
            removeBondOther(targetUsername: usr ?? "")
            print("Remove Bond with usr: \(usr ?? "")")
            }
    }
 
    
    
    
    
}
