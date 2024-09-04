//
//  MyMapWithRepresentableApp.swift
//  MyMapWithRepresentable
//
//  Created by János Székely on 20/03/2024.
//

import SwiftUI

@main
struct MyMapWithRepresentableApp: App {
    @StateObject var locationSearchViewModel = LocationSearchViewModel()
    @StateObject private var locationManager = LocationManager()
    
    var body: some Scene {
        WindowGroup {
            if locationManager.isAuthorized {
                MapView()
                    .environmentObject(locationManager)
                    .environmentObject(locationSearchViewModel)
            } else {
                LocationDeniedView()
            }
        }
    }
}
