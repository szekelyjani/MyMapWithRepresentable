//
//  DetailsView.swift
//  MyMapWithRepresentable
//
//  Created by János Székely on 20/03/2024.
//

import MapKit
import SwiftUI

struct DetailsView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: ViewModel
    var onSearchRouteButtonPressed: () -> ()?
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    selectedPlaceTitle
                    selectedPlaceDescription
                }
                
                Spacer()
                
                closeButton
            }
            Divider()
            Spacer()
            ZStack {
                LookAroundView(tappledLocation: $viewModel.mapSelection,
                               showLookAroundView: $viewModel.showLookAroundView)
            }
            .frame(minHeight: 200)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            showDirectionsbutton
        }
        .onAppear {
            viewModel.fetchLookAroundPreview()
        }
        .padding()
    }
    
    private var closeButton: some View {
        Button {
            viewModel.mapSelection = nil
            dismiss()
        } label: {
            Image(systemName: "xmark.circle.fill")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundStyle(.black, Color(.red).opacity(0.6))
        }
    }
    
    private var selectedPlaceTitle: some View {
        Text(viewModel.mapSelection?.name ?? "")
            .font(.title2)
            .fontWeight(.semibold)
    }
    
    private var selectedPlaceDescription: some View {
        Text(viewModel.mapSelection?.placemark.title ?? "")
            .font(.footnote)
            .foregroundStyle(.gray)
            .lineLimit(2)
            .padding(.trailing)
    }
    
    private var showDirectionsbutton: some View {
        Button {
            viewModel.getDirections = true
            onSearchRouteButtonPressed()
        } label: {
            Text("Get directions")
                .padding()
                .font(.headline)
                .padding()
                .frame(height: 44)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .background(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    init(mapSelection: MKMapItem?, onSearchRouteButtonPressed: @escaping () -> Void) {
        self.onSearchRouteButtonPressed = onSearchRouteButtonPressed
        
        _viewModel = StateObject(wrappedValue: ViewModel(mapSelection: mapSelection))
    }
}
