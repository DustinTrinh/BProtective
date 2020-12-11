//
//  AuthorityAlarmListViewController.swift
//  BProtective
//
//  Created by Dustin Trinh on 2020-11-30.
//  Copyright © 2020 DustyTheCutie. All rights reserved.
//

import UIKit
import Firebase


class AuthorityAlarmListViewController: UITabBarController, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    

    let db = Firestore.firestore()
    var userReference: CollectionReference!
    var usernames : [String] = ["A", "B", "C", "D" ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //tableView.delegate = self
        //tableView.dataSource = self
        
    }
    
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
}
