//
//  ViewController.swift
//  Road Capture
//
//  Created by Aaron Sletten on 1/29/19.
//  Copyright © 2019 Aaron Sletten. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        //Link for finding the distance traveled - Not implimented
        //https://stackoverflow.com/questions/28952747/calculate-total-traveled-distance-ios-swift
        
        //Set up manager
        let manager : CLLocationManager = CLLocationManager();
        manager.delegate = self;
        
        //Request Access to location services
        manager.requestWhenInUseAuthorization();
        
        //Set up activity and accuracy
        manager.activityType = CLActivityType.other;
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        //Request location
        manager.requestLocation();
        
        //Print location
        print(manager.location?.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Print all locations
        for location in locations {
            print(location.coordinate);
        }
    }

    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Caught Error: \(error.localizedDescription)");
    }
        
}

