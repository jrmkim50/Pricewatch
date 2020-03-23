//
//  MapService.swift
//  PriceWatch
//
//  Created by Min on 3/22/20.
//  Copyright © 2020 Min. All rights reserved.
//

import Foundation
import MapKit

struct MapService {
    
    static func determineState(from latitude: CLLocationDegrees, from longitude: CLLocationDegrees, completion: @escaping (String) -> Void ) {
        let reverseGeoCoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        reverseGeoCoder.reverseGeocodeLocation(location, completionHandler: {(placeMarks, error ) in
            if let placeMarks = placeMarks, error == nil && placeMarks.count > 0 {
                guard let state = placeMarks[0].administrativeArea else {
                    return completion("")
                }
                return completion(state)
            } else {
                completion("")
            }
        })
    }
}
