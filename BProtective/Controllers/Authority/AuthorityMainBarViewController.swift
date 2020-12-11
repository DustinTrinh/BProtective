//
//  AuthorityMainBarViewController.swift
//  BProtective
//
//  Created by Dustin Trinh on 2020-09-25.
//  Copyright © 2020 DustyTheCutie. All rights reserved.
//
import UIKit
import MapKit
import Firebase
import CoreLocation

class AuthorityMainBarViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    let locationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    let db = Firestore.firestore()
    var userReference: CollectionReference!
    var saveLat: Double = 0.0
    var saveLon: Double = 0.0
    
    @IBAction func onlineActionPressed(_ sender: Any) {
        updateStatus(status: K.StatusAuthority.online)
    }
    
    @IBAction func offlineActionPressed(_ sender: Any) {
        updateStatus(status: K.StatusAuthority.offline)
    }
    
    @IBAction func refreshLocation(_ sender: Any) {
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        mapView.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
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
    
    func setCurrentLocation(lat: Double, lon: Double){
        self.saveLat = lat
        self.saveLon = lon
    }
    
    func updateLocation(lat: Double, lon: Double) {
        userReference = db.collection(K.Databases.Authority.databaseName)
        
        if let uid = Auth.auth().currentUser?.uid{
            userReference.whereField("UID", isEqualTo: uid)
                .getDocuments() { [self] (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            let docID = document.documentID
                            print("DocID: \(docID)")
                            let updateData = db.collection(K.Databases.Authority.databaseName).document(docID)
                            
                            updateData.updateData([
                                K.Databases.Authority.lat: lat,
                                K.Databases.Authority.lon: lon
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
    
    func updateStatus(status: String) {
        userReference = db.collection(K.Databases.Authority.databaseName)
        
        if let uid = Auth.auth().currentUser?.uid{
            userReference.whereField("UID", isEqualTo: uid)
                .getDocuments() { [self] (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            let docID = document.documentID
                            print("DocID: \(docID)")
                            let updateData = db.collection(K.Databases.Authority.databaseName).document(docID)
                            
                            updateData.updateData([
                                K.Databases.Authority.status: status
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
                            addPins(username: usrname, lat: latMap, lon: lonMap)
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
}
