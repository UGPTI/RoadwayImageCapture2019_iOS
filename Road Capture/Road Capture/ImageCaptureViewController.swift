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

class ImageCaptureViewController: UIViewController {
        
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
    }
}

