//
//  MapTypeSelectView.swift
//  MyMapWithRepresentable
//
//  Created by János Székely on 26/03/2024.
//

import MapKit
import SwiftUI

struct MapTypeSelectView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedMaptype: MapTypeConfig
    
    var body: some View {
        NavigationStack{
            VStack {
                Picker("Map Type", selection: $selectedMaptype.baseType) {
                    ForEach(MapTypeConfig.MapTypes.allCases, id: \.self) { type in
                        Text(type.label)
                    }
                }
                .pickerStyle(.wheel)
                .navigationTitle("Select Map Type")
                Button("OK") {
                    dismiss()
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    MapTypeSelectView(selectedMaptype: .constant(MapTypeConfig.init(baseType: .standard)))
}
