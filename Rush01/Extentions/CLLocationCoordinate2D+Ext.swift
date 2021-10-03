//
//  CLLocationCoordinate2D+Ext.swift
//  Rush01
//
//  Created by out-nazarov2-ms on 03.10.2021.
//

import CoreLocation

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
