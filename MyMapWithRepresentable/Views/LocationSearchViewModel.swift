//
//  LocationSearchViewModel.swift
//  MyMapWithRepresentable
//
//  Created by János Székely on 21/03/2024.
//

import Foundation
import MapKit

@MainActor 
class LocationSearchViewModel: NSObject, ObservableObject {
    @Published var showDetails = false
    @Published var searchResults = [MKMapItem]()
    @Published var selectedLocation: MKMapItem?
    @Published var showRouteDisplaying = false
    @Published var route: MKRoute?
    var searchText = ""
    
    func searchPlaces(region: MKCoordinateRegion) async {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = region
        
        let results = try? await MKLocalSearch(request: request).start()
        searchResults = results?.mapItems ?? []
    }
    
    func selectLocation(_ location: MKMapItem) {
        self.selectedLocation = location
    }
    
    func clearSearch() {
        searchText = ""
        searchResults = []
    }
    
    func fetchRoute() {
        if let selectedLocation {
            Task {
                let request = MKDirections.Request()
                request.source = MKMapItem.forCurrentLocation()
                request.destination = MKMapItem(placemark: MKPlacemark(coordinate: selectedLocation.placemark.coordinate))
                let result = try? await MKDirections(request: request).calculate()
                route = result?.routes.first
                showRouteDisplaying = true
                showDetails = false
            }
        }
    }
    
}
