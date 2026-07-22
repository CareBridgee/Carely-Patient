//
//  AddressMapPickerBottomSheet.swift
//  Carely
//

import SwiftUI
import MapKit

struct AddressMapPickerBottomSheet: View {

    @ObservedObject var viewModel: AddressMapPickerViewModel

    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                MapReader { proxy in
                    Map(position: $viewModel.cameraPosition) {
                        if let coordinate = viewModel.selectedCoordinate {
                            Annotation("", coordinate: coordinate) {
                                Image(systemName: "mappin.circle.fill")
                                    .font(.system(size: 36))
                                    .foregroundColor(.brandPrimary)
                                    .background(
                                        Circle()
                                            .fill(Color.white)
                                            .frame(width: 20, height: 20)
                                    )
                            }
                        }
                    }
                    .onTapGesture { location in
                        if let coordinate = proxy.convert(location, from: .local) {
                            viewModel.selectCoordinate(coordinate)
                        }
                    }
                }
                .edgesIgnoringSafeArea(.bottom)

                VStack(spacing: 0) {
                    searchCard
                        .padding(.horizontal, Spacing.s16)
                        .padding(.top, Spacing.s16)

                    if !viewModel.searchResults.isEmpty {
                        searchResultsList
                            .padding(.horizontal, Spacing.s16)
                    }

                    Spacer()

                    PrimaryButton(title: "Confirm Selected Location") {
                        viewModel.confirmSelectedLocation()
                    }
                    .disabled(!viewModel.canConfirm)
                    .padding(Spacing.s16)
                    .background(
                        LinearGradient(
                            colors: [.clear, Color.backGround.opacity(0.8), Color.backGround],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                }
            }
            .navigationTitle("Select Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        viewModel.closeMapPicker()
                    }
                }
            }
        }
    }

    // MARK: - Search Card

    private var searchCard: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondaryFont)

            TextField("Search for places, streets...", text: Binding(
                get: { viewModel.searchQuery },
                set: { viewModel.updateSearchQuery($0) }
            ))
            .font(.system(size: 16))
            .foregroundColor(.primaryFont)

            if !viewModel.searchQuery.isEmpty {
                Button(action: { viewModel.clearSearch() }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondaryFont)
                }
            }
        }
        .padding(.horizontal, Spacing.s12)
        .frame(height: 50)
        .background(Color.backGround)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
    }

    private var searchResultsList: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(viewModel.searchResults) { result in
                Button(action: { viewModel.selectSearchResult(result) }) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(result.title)
                            .carelyText(style: .bodyRegular, weight: .regular)
                            .foregroundColor(.primaryFont)
                        if !result.subtitle.isEmpty {
                            Text(result.subtitle)
                                .carelyText(style: .bodySmall, weight: .regular)
                                .foregroundColor(.secondaryFont)
                        }
                    }
                    .padding(Spacing.s12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                if result != viewModel.searchResults.last {
                    Divider()
                }
            }
        }
        .background(Color.backGround)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
    }
}
