//
//  PersonPlacemark.swift
//  LunTest
//
//  Created by Maksym Bondar on 2/26/19.
//

import MapKit

class PersonPlacemark: NSObject, MKAnnotation {
    /// Title of user placemark.
    let title: String?
    
    /// Coordinates of user on map.
    var coordinate: CLLocationCoordinate2D
    
    /// Initializer with title and coordinates for user placemark.
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
        super.init()
    }
}
