//
//  MainBarViewController.swift
//  BProtective
//
//  Created by Dustin Trinh on 2020-09-04.
//  Copyright © 2020 DustyTheCutie. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase

class MainBarViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    let locationManager = CLLocationManager()
    var user:NormalUser!
    let db = Firestore.firestore()
    var userReference: CollectionReference!
    var saveLat: Double = 0.0
    var saveLon: Double = 0.0
    
    @IBOutlet weak var mapView: MKMapView!
    @IBAction func safePressed(_ sender: UIButton) {
        updateStatus(status: K.StatusUser.safe)
    }
    @IBAction func unsafePressed(_ sender: UIButton) {
        updateStatus(status: K.StatusUser.unsafe)
        saveAlarms(status: K.StatusUser.unsafe)
    } 
    @IBAction func emergencyPressed(_ sender: UIButton) {
        updateStatus(status: K.StatusUser.emergency)
        saveAlarms(status: K.StatusUser.emergency)
    }
    @IBAction func refreshLocation(_ sender: UIButton) {
        locationManager.startUpdatingLocation()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        mapView.delegate = self
        getEmergency()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            let span = MKCoordinateSpan(latitudeDelta: 0.00775,longitudeDelta: 0.00775)
            let userLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            updateLocation(lat: userLocation.latitude, lon: userLocation.longitude)
            setCurrentLocation(lat: userLocation.latitude, lon: userLocation.longitude)
            let region = MKCoordinateRegion(center: userLocation, span: span)
            mapView.setRegion(region, animated: true)
        }
        self.mapView.showsUserLocation = true
        locationManager.stopUpdatingLocation()
    }
    
    func updateStatus(status: String) {
        userReference = db.collection(K.Databases.NormalUser.databaseName)
        
        if let uid = Auth.auth().currentUser?.uid{
            userReference.whereField("UID", isEqualTo: uid)
                .getDocuments() { [self] (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            let docID = document.documentID
                            print("DocID: \(docID)")
                            let updateData = db.collection(K.Databases.NormalUser.databaseName).document(docID)
                            
                            updateData.updateData([
                                K.Databases.NormalUser.status: status
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
    
    func updateLocation(lat: Double, lon: Double) {
        userReference = db.collection(K.Databases.NormalUser.databaseName)
        
        if let uid = Auth.auth().currentUser?.uid{
            userReference.whereField("UID", isEqualTo: uid)
                .getDocuments() { [self] (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            let docID = document.documentID
                            print("DocID: \(docID)")
                            let updateData = db.collection(K.Databases.NormalUser.databaseName).document(docID)
                            
                            updateData.updateData([
                                K.Databases.NormalUser.lat: lat,
                                K.Databases.NormalUser.lon: lon
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
    
    func setCurrentLocation(lat: Double, lon: Double){
        self.saveLat = lat
        self.saveLon = lon
    }
    
    func getCurrentDate() -> String{
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDate = format.string(from: date)
        return formattedDate
    }
    
    func saveAlarms(status: String) {
        
        let date = getCurrentDate()
        if let email = Auth.auth().currentUser?.email{
            let alarm = Alarms(username: email, lat: saveLat, lon: saveLon, date: date, status: status)
            
            self.db.collection(K.Databases.Alarms.databaseName).addDocument(data: [
                K.Databases.Alarms.username: alarm.username,
                K.Databases.Alarms.lat : alarm.latitude,
                K.Databases.Alarms.lon : alarm.longitude,
                K.Databases.Alarms.date: alarm.date,
                K.Databases.Alarms.status: alarm.status
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
    
    func getEmergency(){
        userReference = db.collection(K.Databases.NormalUser.databaseName)
       
        if let username = Auth.auth().currentUser?.email{
           
            userReference.whereField(K.Databases.NormalUser.status, isEqualTo: K.StatusUser.emergency)
                .getDocuments() { [self] (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err.localizedDescription)")
                    } else {
                        for document in querySnapshot!.documents {
                            
                            let saveData = document.data()
                            let docID = document.documentID
                            let usrname = saveData[K.Databases.NormalUser.email]! as! String
                            let latMap = saveData[K.Databases.NormalUser.lat]! as! Double
                            let lonMap = saveData[K.Databases.NormalUser.lon]! as! Double
                            
                            DispatchQueue.main.async {
                                let checkDistance = self.calculateDistance(firstLat: self.saveLat, firstLon: self.saveLon, secondLat: latMap, secondLon: lonMap)
                                
                                if(checkDistance){
                                    addPins(username: usrname, lat: latMap, lon: lonMap)
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
    
    func calculateDistance(firstLat: Double, firstLon: Double, secondLat: Double, secondLon: Double) -> Bool{
        var result = false
        
        let coordinate0 = CLLocation(latitude: firstLat, longitude: firstLon)
        let coordinate1 = CLLocation(latitude: secondLat, longitude: secondLon)
        let distanceInMeters = coordinate1.distance(from: coordinate0)
        
        if(distanceInMeters < 1000){
            result = true
        }
        else{
            result = false
        }
        return result
    }
}
