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
    var traveledSinceLastResetDistance: Double = 0 //Variable to hold distance since last photo capture
    
    //used to check when to update data
    var isUpdating = false
    
    //Function to execute once
    var triggerFunction = {}
    
    //Distance to set off trigger
    var triggerDistance: Double = 100
    
    init(triggerDistance : Double?, triggerFunction : @escaping ()->Void) {
        super.init()
        self.triggerDistance = triggerDistance ?? 100 //Default 100
        self.triggerFunction = triggerFunction
        
        locationManager.delegate = self
        startTracking()
    }
    
    func startTracking(){
        //Ask for premission to use location services
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse{
            locationManager.requestWhenInUseAuthorization();
        }else{
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = 10
//            locationManager.startUpdatingLocation()
            locationManager.startMonitoringSignificantLocationChanges()
        }
    }
    
    func start(){
        isUpdating = true
    }
    
    func stop(){
        isUpdating = false
        //reset
        startLocation = nil
        lastLocation = nil
        startDate = nil
        totalDistance = 0
        straightDistance = 0
        traveledSinceLastResetDistance = 0
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        startTracking()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if isUpdating{
            //Set Time
            if startDate == nil {
                startDate = Date()
                //Print difference in time
            } else {
                //            print("elapsedTime:", String(format: "%.0fs", Date().timeIntervalSince(startDate)))
            }
            
            //Set location
            if startLocation == nil {
                startLocation = locations.first
                //Calculate distance traveled
            } else if let location = locations.last {
                //Set distances
                deltaDistance = lastLocation.distance(from: location)
                
                traveledSinceLastResetDistance += deltaDistance
                totalDistance += deltaDistance
                straightDistance = startLocation.distance(from: locations.last!)
                
                //Check if over threshold
                if(traveledSinceLastResetDistance >= triggerDistance){
                    //Reset
                    traveledSinceLastResetDistance = 0
                    
                    //Call Take Picture
                    triggerFunction()
                }
                
                //Print
                print("Traveled Distance:\t",  traveledSinceLastResetDistance)
                print("Total Distance:\t\t",  totalDistance)
            }
            lastLocation = locations.last
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if (error as? CLError)?.code == .denied {
            manager.stopUpdatingLocation()
            manager.stopMonitoringSignificantLocationChanges()
        }
    }
}

