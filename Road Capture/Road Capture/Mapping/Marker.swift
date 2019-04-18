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

//Was used to show on a map
class Marker: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var image: UIImage?
    
    init(coordinate: CLLocationCoordinate2D, image: UIImage?) {
        self.coordinate = coordinate
        self.image = image
    }
}
