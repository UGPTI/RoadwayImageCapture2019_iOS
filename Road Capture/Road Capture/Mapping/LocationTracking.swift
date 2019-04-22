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
    var startLocation: CLLocation?
    var lastLocation: CLLocation?
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
    var triggerDistance: Double!
    
    init(triggerFunction : @escaping () -> Void) {
        super.init()
        
        self.triggerDistance = getTriggerDistace()
        self.triggerFunction = triggerFunction
        
        locationManager.delegate = self
//        startTracking()
    }
    
    func getTriggerDistace() -> Double {
//        UserDefaults.standard.set(100, forKey: "distance")
        var distanceInFeet = UserDefaults.standard.double(forKey: "distance")
        
        if distanceInFeet == 0 {
            distanceInFeet = 100
        }
        
        return (Measurement(value: distanceInFeet, unit: UnitLength.feet)).converted(to: .meters).value
    }
    
    func startTracking() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10
        locationManager.requestLocation()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func start() {
        isUpdating = true
    }
    
    func stop() {
        isUpdating = false
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            // If status has not yet been determied, ask for authorization
            manager.requestAlwaysAuthorization()
        case .authorizedWhenInUse:
            // If authorized when in use
            startTracking()
        case .authorizedAlways:
            // If always authorized
            startTracking()
        case .restricted:
            // If restricted by e.g. parental controls. User can't enable Location Services
            manager.requestAlwaysAuthorization()
        case .denied:
            // If user denied your app access to Location Services, but can grant access from Settings.app
            manager.requestAlwaysAuthorization()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("updated location")
        //set trigger distance - do this every time location is updated so you can change distance on the fly
        triggerDistance = getTriggerDistace()
        
        if isUpdating {
            //Set location
            if startLocation == nil {
                startLocation = locations.last
            }
            if lastLocation == nil {
                lastLocation = locations.last
            }
            
            if let location = locations.last {
                //Set distances
                deltaDistance = lastLocation!.distance(from: location)
                
                traveledSinceLastResetDistance += deltaDistance
                totalDistance += deltaDistance
                straightDistance = startLocation!.distance(from: locations.last!)
                
                //Check if over threshold
                if traveledSinceLastResetDistance >= triggerDistance {
                    //Reset
                    traveledSinceLastResetDistance = 0
                    
                    //Call Take Picture
                    triggerFunction()
                }
                
                //Print
                print("Traveled Distance:\t", traveledSinceLastResetDistance)
                print("Total Distance:\t\t", totalDistance)
            }
            lastLocation = locations.last
        } else {
            startDate = Date()
            startLocation = locations.last
            lastLocation = startLocation
            
            deltaDistance = 0
            totalDistance = 0
            straightDistance = 0
            traveledSinceLastResetDistance = 0
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if (error as? CLError)?.code == .denied {
            manager.stopUpdatingLocation()
            manager.stopMonitoringSignificantLocationChanges()
        }
    }
}
