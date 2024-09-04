//
//  DetailsViewViewModel.swift
//  MyMapWithRepresentable
//
//  Created by János Székely on 20/03/2024.
//

import Foundation
import MapKit

extension DetailsView {
    class ViewModel: ObservableObject {
        var getDirections = false
        var lookAroundScene: MKLookAroundScene?
        var mapSelection: MKMapItem?
        var showLookAroundView = false
    
        func fetchLookAroundPreview() {
            if let mapSelection {
                lookAroundScene = nil
                Task {
                    let request = MKLookAroundSceneRequest(mapItem: mapSelection)
                    lookAroundScene = try? await request.scene
                }
            }
        }
    
        init(mapSelection: MKMapItem?) {
            self.mapSelection = mapSelection
        }
        
    }
}
