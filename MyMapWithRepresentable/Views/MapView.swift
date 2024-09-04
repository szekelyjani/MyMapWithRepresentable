//
//  MapView.swift
//  MyMapWithRepresentable
//
//  Created by János Székely on 20/03/2024.
//

import CoreLocation
import SwiftUI
import MapKit

struct MapView: View {
    @EnvironmentObject var locationSearchViewModel: LocationSearchViewModel
    @State private var showMapStyleModifier = false
    @State private var selectedMaptype = MapTypeConfig()
    
    var body: some View {
        NavigationStack {
                ZStack(alignment: .top) {
                    MapViewRepresentable(mapType: selectedMaptype)
                        .ignoresSafeArea()
                        .overlay(alignment: .top) {
                            SearchView()
                                .padding(.horizontal, 12)
                                .background(.ultraThinMaterial)
                                .opacity(locationSearchViewModel.showRouteDisplaying ? 0 : 1)
                        }
                        .overlay(alignment: .bottomTrailing) {
                            mapStyleSelectorButton
                        }
                        .onSubmit(of: .text) {
                            Task {
                                guard !locationSearchViewModel.searchText.isEmpty else { return }
                                await locationSearchViewModel.searchPlaces(region: .userRegion)
                            }
                        }
                        .sheet(isPresented: $locationSearchViewModel.showDetails, onDismiss: {
                            
                        }, content: {
                            if let selectedLocation = locationSearchViewModel.selectedLocation {
                                DetailsView(mapSelection: selectedLocation) {
                                    locationSearchViewModel.fetchRoute()
                                }
                                .presentationDetents([.medium])
                                .interactiveDismissDisabled(false)
                            }
                        })
                        .sheet(isPresented: $showMapStyleModifier) {
                            MapTypeSelectView(selectedMaptype: $selectedMaptype)
                                .presentationDetents([.height(250)])
                        }
                    
                        .safeAreaInset(edge: .bottom) {
                            if locationSearchViewModel.showRouteDisplaying {
                                endRouteButton
                            }
                        }
                }
                .navigationTitle("Map")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(locationSearchViewModel.showRouteDisplaying ? .hidden : .visible, for: .navigationBar)
        }
    }
    
    private var mapStyleSelectorButton: some View {
        Button {
            showMapStyleModifier.toggle()
        } label: {
            Image(systemName: "globe.americas.fill")
                .imageScale(.large)
                .padding(10)
                .background(.background)
                .clipShape(Circle())
                .padding(5)
        }
    }
    
    private var endRouteButton: some View {
        Button("End Route") {
            withAnimation() {
                locationSearchViewModel.showRouteDisplaying = false
                locationSearchViewModel.showDetails = false
                locationSearchViewModel.route = nil
            }
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(.red.gradient, in: .rect(cornerRadius: 15))
        .padding()
        .background(.ultraThinMaterial)
    }
    
}

#Preview {
    MapView()
}

extension CLLocationCoordinate2D {
    static var userLocation: CLLocationCoordinate2D {
        return .init(latitude: 37.3346,
                     longitude: -122.0090)
    }
}

extension MKCoordinateRegion {
    static var userRegion: MKCoordinateRegion {
        return .init(center: .userLocation,
                     span: MKCoordinateSpan(
                        latitudeDelta: 0.1,
                        longitudeDelta: 0.1
                     )
        )
    }
}
