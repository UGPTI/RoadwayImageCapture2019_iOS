//
//  LocationTracking.swift
//  Road Capture
//
//  Created by Aaron Sletten on 2/10/19.
//  Copyright © 2019 Aaron Sletten. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class LocationTracking : NSObject, CLLocationManagerDelegate {
    
    //Link for finding the distance traveled - Not implimented
    //https://stackoverflow.com/questions/28952747/calculate-total-traveled-distance-ios-swift
    
    let locationManager = CLLocationManager()
    //Locations
    var startLocation: CLLocation!
    var lastLocation: CLLocation!
    var startDate: Date!
    //Distances
    var deltaDistance : Double = 0
    var totalDistance: Double = 0
    var straightDistance: Double = 0
    var traveledSinceLastCaptureDistance: Double = 0 //Variable to hold distance since last trigger
    
    //Distance to set off trigger
    var triggerDistance: Double = 100
    
    override init() {
        super.init()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            locationManager.startMonitoringSignificantLocationChanges()
            locationManager.distanceFilter = 10
//            mapView.showsUserLocation = true
//            mapView.userTrackingMode = .follow
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
            
//            addMarker(coordinate: startLocation.coordinate, mapView: mapView, title: "Start")
            //Calculate distance traveled
        } else if let location = locations.last {
            //Set distances
            deltaDistance = lastLocation.distance(from: location)
            
            traveledSinceLastCaptureDistance += deltaDistance
            totalDistance += deltaDistance
            straightDistance = startLocation.distance(from: locations.last!)
            
            //Check if over threshold
            if(traveledSinceLastCaptureDistance >= triggerDistance){
                //Reset
                traveledSinceLastCaptureDistance = 0
                
                //Add placemarkers
//              addMarker(coordinate: location.coordinate, mapView: mapView, title: nil)
            }
            
            //Print
            print("Traveled Distance:",  traveledSinceLastCaptureDistance)
            print("Total Distance:",  totalDistance)
            print("Straight Distance:", straightDistance)
            
//            //Update Labels
//            distanceLabel.text = "Traveled Distance:\t\(traveledDistance)"
//            totalDistanceLabel.text = "Total Distance:\t\t\t\(totalDistance)"
//            straightDistanceLabel.text = "Straight Distance:\t\t\(straightDistance)"
        }
        lastLocation = locations.last
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if (error as? CLError)?.code == .denied {
            manager.stopUpdatingLocation()
            manager.stopMonitoringSignificantLocationChanges()
        }
    }
    
//    //Create marker and add it to the map
//    func addMarker(coordinate: CLLocationCoordinate2D, mapView: MKMapView, title: String?){
//        //Create marker
//        var tempMarker: Marker = Marker(coordinate: coordinate)
//        tempMarker.title = title ?? "Title"
//        
//        //Add Annotation
//        mapView.addAnnotation(tempMarker)
//    }

}

