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
    var saveDistance: Double = 2500
    
    @IBOutlet weak var distanceOutput: UILabel!
    @IBOutlet weak var sliderDisplay: UISlider!
    @IBAction func distanceSlider(_ sender: UISlider) {
        distanceOutput.text = String(sender.value) + " Meters"
        getEmergency(distance: Double(sender.value))
        getUnsafe(distance: Double(sender.value))
    }
    @IBAction func onlineActionPressed(_ sender: Any) {
        updateStatus(status: K.StatusAuthority.online)
        getEmergency(distance: Double(saveDistance))
        getUnsafe(distance: Double(saveDistance))
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
        distanceOutput.text = String(saveDistance) + " Meters"
        sliderDisplay.value = Float(saveDistance)
        getEmergency(distance: saveDistance)
        getUnsafe(distance: saveDistance)
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
    
    func getEmergency(distance: Double){
        mapView.removeAnnotations(mapView.annotations)
        userReference = db.collection(K.Databases.NormalUser.databaseName)
       
        if (Auth.auth().currentUser?.email) != nil{
           
            userReference.whereField(K.Databases.NormalUser.status, isEqualTo: K.StatusUser.emergency)
                .getDocuments() { [self] (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err.localizedDescription)")
                    } else {
                        for document in querySnapshot!.documents {
                            
                            let saveData = document.data()
                            let usrname = saveData[K.Databases.NormalUser.email]! as! String
                            let latMap = saveData[K.Databases.NormalUser.lat]! as! Double
                            let lonMap = saveData[K.Databases.NormalUser.lon]! as! Double
                            
                            DispatchQueue.main.async {
                                let checkDistance = self.calculateDistance(firstLat: self.saveLat, firstLon: self.saveLon, secondLat: latMap, secondLon: lonMap, restrictDistance: distance)
                                
                                if(checkDistance){
                                    addPins(username: usrname, lat: latMap, lon: lonMap, status: K.StatusUser.emergency)
                                }
                                
                            }
                            
                        }
                    }
            }
        }
    }
    
    func getUnsafe(distance: Double){
        mapView.removeAnnotations(mapView.annotations)
        userReference = db.collection(K.Databases.NormalUser.databaseName)
       
        if (Auth.auth().currentUser?.email) != nil{
           
            userReference.whereField(K.Databases.NormalUser.status, isEqualTo: K.StatusUser.unsafe)
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
                            print("Emergency User: \(saveData)" )
                            DispatchQueue.main.async {
                                let checkDistance = self.calculateDistance(firstLat: self.saveLat, firstLon: self.saveLon, secondLat: latMap, secondLon: lonMap, restrictDistance: distance)
                                
                                if(checkDistance){
                                    addPins(username: usrname, lat: latMap, lon: lonMap, status: K.StatusUser.unsafe)
                                }
                                
                            }
                        }
                    }
            }
        }
    }
    
    func addPins(username: String, lat: Double, lon: Double, status: String){
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        annotation.title = username
        annotation.subtitle = status
        
        mapView.addAnnotation(annotation)
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "MyMarker")
        if(annotation.subtitle == K.StatusUser.emergency){
            annotationView.markerTintColor = UIColor.red
        }
        else if(annotation.subtitle == K.StatusUser.unsafe){
            annotationView.markerTintColor = UIColor.yellow
        }
        
        
        return annotationView
    }
    
    func calculateDistance(firstLat: Double, firstLon: Double, secondLat: Double, secondLon: Double, restrictDistance: Double) -> Bool{
        var result = false
        
        let coordinate0 = CLLocation(latitude: firstLat, longitude: firstLon)
        let coordinate1 = CLLocation(latitude: secondLat, longitude: secondLon)
        let distanceInMeters = coordinate1.distance(from: coordinate0)
        print("Distance \(distanceInMeters)")
        if( distanceInMeters <= restrictDistance ){
            result = true
        }
        else{
            result = false
        }
        return result
    }
}
