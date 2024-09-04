//
//  SearchView.swift
//  MyMapWithRepresentable
//
//  Created by János Székely on 21/03/2024.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var locationSearchViewModel: LocationSearchViewModel
    @FocusState private var isSearchInFocus: Bool
    
    var body: some View {
        HStack {
            HStack {
                searchIcon
                searchTextField
                Spacer()
                closeButton
                .opacity(isSearchInFocus ? 1 : 0)
            }
            .padding(6)
            .background(
                Rectangle()
                    .fill(.ultraThinMaterial)
            )
            .clipShape(.rect(cornerRadius: 6))
            if isSearchInFocus {
                cancelButton
            }
        }
        .font(.subheadline)
        .frame(width: UIScreen.main.bounds.width - 24, height: 55)
    }
    
    private var searchIcon: some View {
        Image(systemName: "magnifyingglass")
    }
    
    private var searchTextField: some View {
        TextField("Search", text: $locationSearchViewModel.searchText)
            .focused($isSearchInFocus)
            .font(.title3)
    }
    
    private var closeButton: some View {
        Button {
            withAnimation {
                locationSearchViewModel.clearSearch()
                isSearchInFocus = false
            }
        } label: {
            Image(systemName: "xmark.circle.fill")
                .tint(.gray)
        }
    }
    
    private var cancelButton: some View {
        Button("Cancel") {
            withAnimation {
                locationSearchViewModel.clearSearch()
                isSearchInFocus = false
            }
        }
    }
}

#Preview {
    SearchView()
}
