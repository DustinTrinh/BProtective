//
//  AlarmListViewController.swift
//  BProtective
//
//  Created by Dustin Trinh on 2020-11-30.
//  Copyright © 2020 DustyTheCutie. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class AlarmListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    var usernames : [String] = []
    let db = Firestore.firestore()
    var userReference: CollectionReference!
    var refresh = UIRefreshControl()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = K.Titles.alarmList
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        getEmergencyNames()
        refresh.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresh.addTarget(self, action: #selector(self.refreshTable(_:)), for: .valueChanged)
        tableView.addSubview(refresh)
    }
    
    func getEmergencyNames(){
        userReference = db.collection(K.Databases.NormalUser.databaseName)
        if let username = Auth.auth().currentUser?.email{
           
            userReference.whereField(K.Databases.NormalUser.status, isEqualTo: K.StatusUser.emergency)
                .getDocuments() { [self] (querySnapshot, err) in
                    usernames = []
                    if let err = err {
                        print("Error getting documents: \(err.localizedDescription)")
                    } else {
                        for document in querySnapshot!.documents {
                            
                            let saveData = document.data()
                            let docID = document.documentID
                            let usrname = saveData[K.Databases.NormalUser.email]! as! String
                            usernames.append(usrname)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.usernames.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                    }
            }
        }
    }
    
    @objc func refreshTable(_ sender: AnyObject) {
       getEmergencyNames()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        usernames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let usr = usernames[indexPath.row]
       
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Table.emergencyList, for: indexPath)
        cell.textLabel?.text = usr
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("CLicked \(usernames[indexPath.row])")
        let vc = storyboard?.instantiateViewController(identifier: "AlarmPathViewController") as? AlarmPathViewController
        vc?.username = usernames[indexPath.row] 
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
