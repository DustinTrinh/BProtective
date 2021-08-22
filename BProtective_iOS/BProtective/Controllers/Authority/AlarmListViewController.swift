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
    var saveDistance:Double = 2500
    var saveLat: Double = 0.0
    var saveLon: Double = 0.0
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var sliderValue: UILabel!
    @IBOutlet weak var sliderDisplay: UISlider!
    @IBAction func sliderChange(_ sender: UISlider) {
        sliderValue.text = String(sender.value) + " Meters"
        saveDistance = Double(sender.value)
        getEmergencyNames(distance: Double(sender.value))
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = K.Titles.alarmList
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        getCurrentLocation()
        sliderDisplay.value = Float(saveDistance)
        sliderValue.text = String(saveDistance) + " Meters"
        refresh.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresh.addTarget(self, action: #selector(self.refreshTable(_:)), for: .valueChanged)
        tableView.addSubview(refresh)
        getEmergencyNames(distance: saveDistance)
        print("Print Out 4 \(saveLon) \(saveLat)")
    }
    
    func getEmergencyNames(distance: Double){
        userReference = db.collection(K.Databases.NormalUser.databaseName)
        usernames = []
        if (Auth.auth().currentUser?.email) != nil{
           
            userReference.whereField(K.Databases.NormalUser.status, isEqualTo: K.StatusUser.emergency)
                .getDocuments() { [self] (querySnapshot, err) in
                    
                    if let err = err {
                        print("Error getting documents: \(err.localizedDescription)")
                    } else {
                        for document in querySnapshot!.documents {
                            
                            let saveData = document.data()
                            _ = document.documentID
                            let usrname = saveData[K.Databases.NormalUser.email]! as! String
                            
                            let latMap = saveData[K.Databases.NormalUser.lat]! as! Double
                            let lonMap = saveData[K.Databases.NormalUser.lon]! as! Double
                            
                            let checkDistance = self.calculateDistance(firstLat: self.saveLat, firstLon: self.saveLon, secondLat: latMap, secondLon: lonMap, restrictDistance: distance)
                            
                            if(checkDistance){
                                usernames.append(usrname)
                            }
                            
                            print("Print Out 1 \(saveLat) \(saveLon)")
                            
                            DispatchQueue.main.async {
                                /*
                                
                                */
                                if(usernames.isEmpty){
                                    let emp = "Empty: No Emergency available"
                                    usernames.append(emp)
                                }
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
       getEmergencyNames(distance: saveDistance)
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
    
    func calculateDistance(firstLat: Double, firstLon: Double, secondLat: Double, secondLon: Double, restrictDistance: Double) -> Bool{
        var result = false
        
        let coordinate0 = CLLocation(latitude: firstLat, longitude: firstLon)
        let coordinate1 = CLLocation(latitude: secondLat, longitude: secondLon)
        let distanceInMeters = coordinate1.distance(from: coordinate0)
        print("Distance \(distanceInMeters)")
        print("Print Out 2 \(firstLat) \(firstLon) \(secondLat) \(secondLon)")
        
        if( distanceInMeters <= restrictDistance ){
            result = true
        }
        else{
            result = false
        }
        return result
    }
    func setCurrentLocation(lat: Double, lon: Double){
        self.saveLat = lat
        self.saveLon = lon
    }
    func getCurrentLocation(){
        userReference = db.collection(K.Databases.Authority.databaseName)
       
        if let username = Auth.auth().currentUser?.email{
           
            userReference.whereField(K.Databases.Authority.email, isEqualTo: username)
                .getDocuments() { [self] (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err.localizedDescription)")
                    } else {
                        for document in querySnapshot!.documents {
                            
                            let saveData = document.data()
                            let latMap = saveData[K.Databases.Authority.lat]! as! Double
                            let lonMap = saveData[K.Databases.Authority.lon]! as! Double
                            print("Print out 3: \(latMap) \(lonMap)")
                            setCurrentLocation(lat: latMap, lon: lonMap)
                            
                            DispatchQueue.main.async {
                                setCurrentLocation(lat: latMap, lon: lonMap)
                            }
                        }
                    }
            }
        }
    }
}
