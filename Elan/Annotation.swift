//
//  Annotation.swift
//  MapViewFun
//
//  Created by srinivasan s on 24/09/14.
//  Copyright (c) 2014 srinivasan s. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class Annotation:NSObject,MKAnnotation
{
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var isCurrentLocation:Bool?
    
    init(coord:CLLocationCoordinate2D)
    {
        self.coordinate=coord;
    }
}
