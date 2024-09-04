//
//  LookAroundView.swift
//  MyMapWithRepresentable
//
//  Created by János Székely on 20/03/2024.
//

import MapKit
import SwiftUI

struct LookAroundView: UIViewControllerRepresentable {
    
    @Binding var tappledLocation: MKMapItem?
    @Binding var showLookAroundView: Bool
    
    func makeUIViewController(context: Context) -> MKLookAroundViewController {
        return MKLookAroundViewController()
    }
    
    func updateUIViewController(_ uiViewController: MKLookAroundViewController, context: Context) {
        if let tappledLocation {
            Task {
                if let scene = await getScene(for: tappledLocation) {
                    withAnimation {
                        self.showLookAroundView = true
                        uiViewController.scene = scene
                    }
                } else {
                    withAnimation {
                        self.showLookAroundView = false
                    }
                    return
                }
            }
        }
    }
    
    func getScene(for tappedLocation: MKMapItem?) async -> MKLookAroundScene? {
        if let tappedLocation {
            let sceneRequest = MKLookAroundSceneRequest(mapItem: tappedLocation)
            do {
                return try await sceneRequest.scene
            } catch {
                print(error.localizedDescription)
                return nil
            }
        } else {
            return nil
        }
    }
}
