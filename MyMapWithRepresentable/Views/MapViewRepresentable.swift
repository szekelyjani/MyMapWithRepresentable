//
//  MapViewRepresentable.swift
//  MyMapWithRepresentable
//
//  Created by János Székely on 20/03/2024.
//

import MapKit
import SwiftUI

struct MapViewRepresentable: UIViewRepresentable {
    
    let mapView = MKMapView()
    var locationManager = LocationManager()
    @EnvironmentObject var locationSearchViewModel: LocationSearchViewModel
    var mapType: MapTypeConfig
    
    func makeUIView(context: Context) -> some UIView {
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.mapType = mapType.mapType
        return mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        context.coordinator.updateMapType(to: mapType.mapType)
        if locationSearchViewModel.searchResults.isEmpty {
            context.coordinator.removeAnnotations()
            context.coordinator.recenterOnUserLocation()
        } else {
            for result in locationSearchViewModel.searchResults {
                context.coordinator.addAnnotation(result)
            }
        }
        if let route = locationSearchViewModel.route {
            context.coordinator.showRoute(route)
        } else {
            context.coordinator.removeRoute()
        }
    }
    
    func makeCoordinator() -> MapViewCoordinator {
        MapViewCoordinator(parent: self)
    }
    
}

extension MapViewRepresentable {
    
    class MapViewCoordinator: NSObject, MKMapViewDelegate {
        var parent: MapViewRepresentable
        var currentRegion: MKCoordinateRegion?
        
        init(parent: MapViewRepresentable) {
            self.parent = parent
            super.init()
        }
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,
                                               longitude: userLocation.coordinate.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            )
            self.currentRegion = region
            parent.mapView.setRegion(region, animated: true)
        }
        
        @MainActor func mapView(_ mapView: MKMapView, didSelect annotation: any MKAnnotation) {
            let placemark = parent.locationSearchViewModel.searchResults.filter { $0.placemark.coordinate == annotation.coordinate }.first
            if let placemark {
                parent.locationSearchViewModel.selectedLocation = placemark
                parent.locationSearchViewModel.showDetails = true
            }
        }
        
        func recenterOnUserLocation() {
            if let currentRegion {
                parent.mapView.setRegion(currentRegion, animated: true)
            }
        }
        
        func addAnnotation(_ place: MKMapItem) {
            let annotation = MKPointAnnotation()
            annotation.coordinate = place.placemark.coordinate
            
            parent.mapView.addAnnotation(annotation)
        }
        
        func removeAnnotations() {
            parent.mapView.removeAnnotations(parent.mapView.annotations)
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: any MKOverlay) -> MKOverlayRenderer {
            let polyline = MKPolylineRenderer(overlay: overlay)
            polyline.strokeColor = .blue
            polyline.lineWidth = 6
            return polyline
        }
        
        func showRoute(_ route: MKRoute) {
            parent.mapView.addOverlay(route.polyline)
            parent.mapView.setVisibleMapRect(route.polyline.boundingMapRect,
                                             edgePadding: UIEdgeInsets(
                                                top: 30,
                                                left: 20,
                                                bottom: 100,
                                                right: 20
                                             ),
                                             animated: true)
        }
        
        func removeRoute() {
            parent.mapView.removeOverlays(parent.mapView.overlays)
            recenterOnUserLocation()
        }
        
        func updateMapType(to mapType: MKMapType) {
            parent.mapView.mapType = mapType
        }
    }
}

extension CLLocationCoordinate2D: Equatable {}

public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
}
