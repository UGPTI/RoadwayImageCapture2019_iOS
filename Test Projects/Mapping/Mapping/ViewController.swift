//
//  ViewController.swift
//  Mapping
//
//  Created by Aaron Sletten on 2/21/19.
//  Copyright © 2019 Aaron Sletten. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    
    var locationTracker : LocationTracking?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up LocationTracking
        locationTracker = LocationTracking.init(triggerDistance: 100, triggerFunction: takePicture)
        
        //Set up map
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.setUserTrackingMode(.follow, animated: true)   
    }

    func takePicture(){
        print("Take picture")
        addMarker(coordinate: locationTracker!.lastLocation.coordinate, mapView: mapView, title: "Title")
    }
    
    func addMarker(coordinate: CLLocationCoordinate2D, mapView: MKMapView, title: String?){
        //Create marker
        let tempMarker: Marker = Marker(coordinate: coordinate, image: UIImage(named: "1.PNG"))
        tempMarker.title = title ?? "Title"

        //Add Annotation
        mapView.addAnnotation(tempMarker)
    }
}

