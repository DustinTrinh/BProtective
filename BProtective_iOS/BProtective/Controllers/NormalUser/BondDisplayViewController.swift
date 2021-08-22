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
import MaterialComponents

class BondDisplayViewController: UIViewController{
    let db = Firestore.firestore()
    var userReference: CollectionReference!
    var ref: DatabaseReference!

    let delay = 2 // seconds
    
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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func privacy1Set(_ sender: Any) {
        self.activityIndicator.startAnimating()
        
        if(lPrivacy.text == "1") {
            self.activityIndicator.stopAnimating()
        }
        else {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
                self.changePrivacySelf(pri: "1")
                self.changePrivacyForeign(pri: "1")
                self.getUserData()
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    @IBAction func privacy2Set(_ sender: Any) {
        self.activityIndicator.startAnimating()

        if(lPrivacy.text == "2") {
            self.activityIndicator.stopAnimating()
        }
        else {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
                self.changePrivacySelf(pri: "2")
                self.changePrivacyForeign(pri: "2")
                self.getUserData()
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    @IBAction func privacy3Set(_ sender: Any) {
        
        self.activityIndicator.startAnimating()
        
        if(lPrivacy.text == "3") {
            self.activityIndicator.stopAnimating()
        }
        else {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
                self.changePrivacySelf(pri: "3")
                self.changePrivacyForeign(pri: "3")
                self.getUserData()
                self.activityIndicator.stopAnimating()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Variables -> \(privacy) - \(fPrivacy) - \(_username)")
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
        title = K.Titles.privacyBondTitle
        nullUser.isHidden = true
        lPrivacy.text = privacy
        fPrivacy.text = fprivacy
        getUserData()
        
        let colorScheme = ApplicationScheme.shared.colorScheme
        self.view.tintColor = colorScheme.onSurfaceColor
        self.view.backgroundColor = colorScheme.surfaceColor
        self.lPrivacy.textColor = colorScheme.secondaryColor
        self.fPrivacy.textColor = colorScheme.secondaryColor
        self.activityIndicator.hidesWhenStopped = true
    }
    
    func displayBond(){
        print("WHAT \(fLat) \(fLon) \(fprivacy)")
        if(fprivacy == "3" && stt != K.StatusUser.emergency){
            nullUser.isHidden = false
            print("Situation 1")
        }
        else if(fprivacy == "3" && stt == K.StatusUser.emergency){
            nullUser.isHidden = true
            addPins(username: _username, lat: fLat, lon: fLon )
            print("Situation 2")
        }
        
        else if(fprivacy == "2" && stt == K.StatusUser.emergency || stt == K.StatusUser.unsafe){
            nullUser.isHidden = true
            addPins(username: _username, lat: fLat, lon: fLon )
            print("Situation 3")
        }
        else if(fprivacy == "1"){
            print("Situation 4")
            nullUser.isHidden = true
            addPins(username: _username, lat: fLat, lon: fLon )
        }
        else{
            nullUser.isHidden = false
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
                            for bond in storeData1{
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
                        DispatchQueue.main.async {
                            lPrivacy.text = pri
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
                            for bond in storeData1{
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
                            DispatchQueue.main.async {
                                
                                //fPrivacy.text = pri
                                
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

        if (Auth.auth().currentUser?.email) != nil{
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
