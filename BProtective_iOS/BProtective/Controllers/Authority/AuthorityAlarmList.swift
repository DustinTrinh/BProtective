//
//  AuthorityAlarmList.swift
//  BProtective
//
//  Created by Dustin Trinh on 2020-09-25.
//  Copyright © 2020 DustyTheCutie. All rights reserved.
//

import UIKit
import Firebase

class AuthorityAlarmListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    

    
    let db = Firestore.firestore()
    var userReference: CollectionReference!
    var usernames : [String] = []

    @IBOutlet weak var tableViews: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //tableViews.dataSource = self
        //getEmergencyNames()
    }
    
    /*
    //DISPLAY LIST OF ALARMS
    //Get Emergency Names
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
                            usernames.append(saveData[K.Databases.NormalUser.email]! as! String)
                            
                            print(usernames)
                            DispatchQueue.main.async {
                                
                                self.tableViews.reloadData()
                                let indexPath = IndexPath(row: self.usernames.count - 1, section: 0)
                                self.tableViews.scrollToRow(at: indexPath, at: .top, animated: true)
                                
                            }
                        }
                    }
            }
        }
    }
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usernames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let usr = usernames[indexPath.row]
       
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Table.emergencyList, for: indexPath)
        cell.textLabel?.text = usr
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            usernames.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            
            //REMOVE BONDS FROM BOTH SIDE
            
            } else if editingStyle == .insert {
                // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
            }
    }
    
    //CLICK INTO CELL TO SHOW MAP AND PATHxs
}
