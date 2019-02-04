//
//  Marker.swift
//  Road Capture
//
//  Created by Aaron Sletten on 2/3/19.
//  Copyright © 2019 Aaron Sletten. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class Marker: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    init(coordinate: CLLocationCoordinate2D){
        self.coordinate = coordinate
    }
}
