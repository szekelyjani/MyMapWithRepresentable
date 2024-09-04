//
//  LocationManager.swift
//  MyMapWithRepresentable
//
//  Created by János Székely on 20/03/2024.
//

import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    private let locationManager = CLLocationManager()
    var userLocation: CLLocation?
    @Published var isAuthorized = false
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
        startLocationServices()
    }
    
    private func startLocationServices() {
        if locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            isAuthorized = true
        } else {
            isAuthorized = false
            locationManager.requestWhenInUseAuthorization()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.last
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            isAuthorized = false
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            isAuthorized = false
            print("Access denied")
        case .authorized, .authorizedWhenInUse, .authorizedAlways:
            isAuthorized = true
        default:
            isAuthorized = true
            startLocationServices()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error.localizedDescription)
    }
    
}

//extension LocationManager: CLLocationManagerDelegate {
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard !locations.isEmpty else { return }
//        locationManager.stopUpdatingLocation()
//    }
//    
//    
//}
