//
//  MapTypeConfig.swift
//  MyMapWithRepresentable
//
//  Created by János Székely on 26/03/2024.
//

import Foundation
import MapKit

struct MapTypeConfig {
    
    enum MapTypes: CaseIterable {
        case standard, hybrid, satellite
        var label: String {
            switch self {
            case .standard:
                "Standard"
            case .hybrid:
                "Satellite with roads"
            case .satellite:
                "Satellite only"
            }
        }
    }
    
    var baseType = MapTypes.standard
    
    var mapType: MKMapType {
        switch baseType {
        case .standard:
            MKMapType.standard
        case .hybrid:
            MKMapType.hybrid
        case .satellite:
            MKMapType.satellite
        }
    }
}
