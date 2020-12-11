//
//  AlarmPathViewController.swift
//  BProtective
//
//  Created by Dustin Trinh on 2020-12-01.
//  Copyright © 2020 DustyTheCutie. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import CoreLocation

class AlarmPathViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    let db = Firestore.firestore()
    var userReference: CollectionReference!
    var myLat : Double = 0.0
    var myLon : Double = 0.0
    let locationManager = CLLocationManager()
    var username = ""
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var distance: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = K.Titles.emergencyPath
        locationManager.delegate = self
        mapView.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        getLatLon(email: username)
    }
    
    //Get current Location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            let span = MKCoordinateSpan(latitudeDelta: 0.00775,longitudeDelta: 0.00775)
            let userLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            setCurrentLocation(lat: userLocation.latitude, lon: userLocation.longitude)
            let region = MKCoordinateRegion(center: userLocation, span: span)
            mapView.setRegion(region, animated: true)
        }
        self.mapView.showsUserLocation = true
        locationManager.stopUpdatingLocation()
    }
    
    func setCurrentLocation(lat: Double, lon: Double){
        self.myLat = lat
        self.myLon = lon
    }
    
    //Get location of the alarm
    func getLatLon(email: String){
        userReference = db.collection(K.Databases.NormalUser.databaseName)
       
        if let usernameAuthority = Auth.auth().currentUser?.email{
           
            userReference.whereField(K.Databases.NormalUser.email, isEqualTo: email)
                .getDocuments() { [self] (querySnapshot, err) in
                    
                    if let err = err {
                        print("Error getting documents: \(err.localizedDescription)")
                    } else {
                        for document in querySnapshot!.documents {
                            
                            let saveData = document.data()
                            let docID = document.documentID
                            let getLat = saveData[K.Databases.NormalUser.lat]! as! Double
                            let getLon = saveData[K.Databases.NormalUser.lon]! as! Double
                            addPins(username: username, lat: getLat, lon: getLon)
                            drawRoute(sourceLat: myLat, sourceLon: myLon, destLat: getLat, destLon: getLon)
                            /*
                            DispatchQueue.main.async {
                                addPins(username: username, lat: getLat, lon: getLon)
                                drawRoute(sourceLat: myLat, sourceLon: myLon, destLat: getLat, destLon: getLon)
                            }
 */
                        }
                    }
            }
        }
    }
    //add pin
    func addPins(username: String, lat: Double, lon: Double){
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        annotation.title = username
        mapView.addAnnotation(annotation)
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
        
        print("Pin Added")
    }
    
    //Draw path
    func drawRoute(sourceLat: Double, sourceLon: Double, destLat: Double, destLon: Double){
        
        let sourceCoor = CLLocationCoordinate2D(latitude: sourceLat, longitude: sourceLon)
        let destCoor = CLLocationCoordinate2D(latitude: destLat, longitude: destLon)
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoor)
        let destPlacemark = MKPlacemark(coordinate: destCoor)
        
        let sourceItem = MKMapItem(placemark: sourcePlacemark)
        let destItem = MKMapItem(placemark: destPlacemark)
        
        let destRequest = MKDirections.Request()
        destRequest.source = sourceItem
        destRequest.destination = destItem
        destRequest.transportType = .automobile
        
        let directions = MKDirections(request: destRequest)
        directions.calculate { (response, err) in
            guard let response = response else{
                if let error = err{
                    print("Something is Wrong: \(error)")
                }
                return
            }
            let route = response.routes[0]
            self.mapView.addOverlay(route.polyline)
            self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        render.strokeColor = .red
        return render
    }
}
