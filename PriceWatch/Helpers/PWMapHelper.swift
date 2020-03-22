//
//  PWMapHelper.swift
//  PriceWatch
//
//  Created by Min on 3/19/20.
//  Copyright © 2020 Min. All rights reserved.
//

import Foundation
import MapKit

class PWMapHelper: NSObject {
    func setRegion(latitude: CLLocationDegrees, longitude: CLLocationDegrees, latZoomLevel: CLLocationDegrees = 0.03,
                   longZoomLevel: CLLocationDegrees = 0.03) -> MKCoordinateRegion {
        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latZoomLevel, longitudeDelta: longZoomLevel)
        let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region: MKCoordinateRegion = MKCoordinateRegion(center: location, span: span)
        return region
    }
}
