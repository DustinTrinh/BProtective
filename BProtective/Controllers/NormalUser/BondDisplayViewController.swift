//
//  BondDisplayViewController.swift
//  BProtective
//
//  Created by Dustin Trinh on 2021-02-13.
//  Copyright © 2021 DustyTheCutie. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import CoreLocation

class BondDisplayViewController: UIViewController{
    let db = Firestore.firestore()
    var userReference: CollectionReference!
    var ref: DatabaseReference!

    var myLat : Double = 0.0
    var myLon : Double = 0.0
    let locationManager = CLLocationManager()
    var _username = ""
    var privacy = ""
    var fprivacy = ""
    var stt = ""
    var fLat : Double = 0.0
    var fLon : Double = 0.0
    
    @IBOutlet weak var lPrivacy: UILabel!
    @IBOutlet weak var fPrivacy: UILabel!
    @IBOutlet weak var nullUser: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func privacy1Set(_ sender: Any) {
        changePrivacySelf(pri: "1")
        changePrivacyForeign(pri: "1")
        lPrivacy.text = "1"
        getUserData()
    }
    @IBAction func privacy2Set(_ sender: Any) {
        changePrivacySelf(pri: "2")
        changePrivacyForeign(pri: "2")
        lPrivacy.text = "2"
        getUserData()
    }
    @IBAction func privacy3Set(_ sender: Any) {
        changePrivacySelf(pri: "3")
        changePrivacyForeign(pri: "3")
        lPrivacy.text = "3"
        getUserData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
        title = K.Titles.privacyBondTitle
        nullUser.isHidden = true
        lPrivacy.text = privacy
        fPrivacy.text = fprivacy
        getUserData()
    }
    
    func displayBond(){
        print("WHAT \(fLat) \(fLon)")
        if(fprivacy == "3" && stt != K.StatusUser.emergency){
            nullUser.isHidden = false
        }
        else if(fprivacy == "3" && stt == K.StatusUser.emergency){
            nullUser.isHidden = true
            addPins(username: _username, lat: fLat as! Double, lon: fLon as! Double)
        }
        
        if(fprivacy == "2" && stt == K.StatusUser.emergency || stt == K.StatusUser.unsafe){
            nullUser.isHidden = true
            addPins(username: _username, lat: fLat as! Double, lon: fLon as! Double)
        }
        else{
            nullUser.isHidden = false
        }
        
        if(fprivacy == "1"){
            
            nullUser.isHidden = true
            addPins(username: _username, lat: fLat as! Double, lon: fLon as! Double)
        }
    }
    
    func changePrivacySelf(pri: String){
        userReference = db.collection(K.Databases.BondList.databaseName)
        
        
        if let usr = Auth.auth().currentUser?.email{
            userReference.whereField(K.Databases.BondList.username, isEqualTo: usr)
                .getDocuments() { [self] (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            let docID = document.documentID
                            print("DocID: \(docID)")
                            let updateData = db.collection(K.Databases.BondList.databaseName).document(docID)
                            
                            let storeData = document.data()
                            var storeData1 = storeData[K.Databases.BondList.bonds]! as! [Dictionary<String, String>]
                            var i = 0
                            for var bond in storeData1{
                                if(bond[K.Databases.BondList.username] == _username){
                                    storeData1[i][K.Databases.BondList.privacy] = pri
                                }
                                i+=1
                            }
                            
                            updateData.updateData([
                                "bonds": storeData1
                            ]) { err in
                                if let err = err {
                                    print("Error updating document: \(err)")
                                } else {
                                    print("Document successfully updated")
                                }
                            }
                            
                        }
                    }
            }
        }
    }
    
    func changePrivacyForeign(pri: String){
        userReference = db.collection(K.Databases.BondList.databaseName)
        
        
        if let usr = Auth.auth().currentUser?.email{
            userReference.whereField(K.Databases.BondList.username, isEqualTo: _username)
                .getDocuments() { [self] (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            let docID = document.documentID
                            print("DocID: \(docID)")
                            let updateData = db.collection(K.Databases.BondList.databaseName).document(docID)
                            
                            let storeData = document.data()
                            var storeData1 = storeData[K.Databases.BondList.bonds]! as! [Dictionary<String, String>]
                            var i = 0
                            for var bond in storeData1{
                                if(bond[K.Databases.BondList.username] == usr){
                                    storeData1[i][K.Databases.BondList.fprivacy] = pri
                                }
                                i+=1
                            }
                            
                            updateData.updateData([
                                "bonds": storeData1
                            ]) { err in
                                if let err = err {
                                    print("Error updating document: \(err)")
                                } else {
                                    print("Document successfully updated")
                                }
                            }
                            
                        }
                    }
            }
        }
    }
    
    func addPins(username: String, lat: Double, lon: Double){
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        annotation.title = username
        mapView.addAnnotation(annotation)
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
    }
    
    func getUserData() {
        userReference = db.collection(K.Databases.NormalUser.databaseName)

        if let username = Auth.auth().currentUser?.email{
            userReference.whereField(K.Databases.NormalUser.username, isEqualTo: _username)
                .getDocuments() { [self] (querySnapshot, err) in
                  
                    if let err = err {
                        print("Error getting documents: \(err.localizedDescription)")
                    } else {
                        for document in querySnapshot!.documents {
                            
                            let saveData = document.data()
                            
                            print("WHAT \(fLat) \(fLon)")
                            DispatchQueue.main.async {
                                stt = saveData[K.Databases.NormalUser.status] as! String
                                fLat = saveData[K.Databases.NormalUser.lat] as! Double
                                fLon = saveData[K.Databases.NormalUser.lon] as! Double
                                
                                displayBond()
                            }
                            
                            
                        }
                    }
            }
        }
    }
}
