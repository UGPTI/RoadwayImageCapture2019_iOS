//
//  ViewController.swift
//  Road Capture
//
//  Created by Aaron Sletten on 1/29/19.
//  Copyright © 2019 Aaron Sletten. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ImageCaptureViewController: UIViewController, CLLocationManagerDelegate {
    
    //Link for finding the distance traveled - Not implimented
    //https://stackoverflow.com/questions/28952747/calculate-total-traveled-distance-ios-swift
    
    let locationManager = CLLocationManager()
    var startLocation: CLLocation!
    var lastLocation: CLLocation!
    var startDate: Date!
    var traveledDistance: Double = 0
    var totalDistance: Double = 0
    var straightDistance: Double = 0
    
    //Distance to set off trigger
    var triggerDistance: Double = 100
    //Variable to hold distance since last trigger
    var triggerDistanceBuffer: Double = 0
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var totalDistanceLabel: UILabel!
    @IBOutlet weak var straightDistanceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Make sure labels are on top
        self.view.bringSubviewToFront(distanceLabel)
        self.view.bringSubviewToFront(totalDistanceLabel)
        self.view.bringSubviewToFront(straightDistanceLabel)
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            locationManager.startMonitoringSignificantLocationChanges()
            locationManager.distanceFilter = 10
            mapView.showsUserLocation = true
            mapView.userTrackingMode = .follow
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Set Time
        if startDate == nil {
            startDate = Date()
        //Print difference in time
        } else {
            print("elapsedTime:", String(format: "%.0fs", Date().timeIntervalSince(startDate)))
        }
        
        //Set location
        if startLocation == nil {
            startLocation = locations.first
            
            addMarker(coordinate: startLocation.coordinate, mapView: mapView, title: "Start")
        //Calculate distance traveled
        } else if let location = locations.last {
            //Set distances
            traveledDistance += lastLocation.distance(from: location)
            totalDistance += traveledDistance
            triggerDistanceBuffer += traveledDistance;
            straightDistance = startLocation.distance(from: locations.last!)
            
            //Add placemarkers
            if(triggerDistanceBuffer >= triggerDistance){
                //Reset buffer
                triggerDistanceBuffer = 0
                
                addMarker(coordinate: location.coordinate, mapView: mapView, title: nil)
            }
            
            //Print
            print("Traveled Distance:",  traveledDistance)
            print("Total Distance:",  totalDistance)
            print("Straight Distance:", straightDistance)
            
            //Update Labels
            distanceLabel.text = "Traveled Distance:\t\(traveledDistance)"
            totalDistanceLabel.text = "Total Distance:\t\t\t\(totalDistance)"
            straightDistanceLabel.text = "Straight Distance:\t\t\(straightDistance)"
        }
        lastLocation = locations.last
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if (error as? CLError)?.code == .denied {
            manager.stopUpdatingLocation()
            manager.stopMonitoringSignificantLocationChanges()
        }
    }
    
    //Create marker and add it to the map
    func addMarker(coordinate: CLLocationCoordinate2D, mapView: MKMapView, title: String?){
        //Create marker
        var tempMarker: Marker = Marker(coordinate: coordinate)
        tempMarker.title = title ?? "Title"
        
        //Add Annotation
        mapView.addAnnotation(tempMarker)
    }
}

