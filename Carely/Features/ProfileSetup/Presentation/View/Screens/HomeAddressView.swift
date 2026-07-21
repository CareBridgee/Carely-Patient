//
//  HomeAddressView.swift
//  Carely
//
//  Created by Mohamed Ayman on 19/07/2026.
//

import SwiftUI

struct HomeAddressView: View {

    @StateObject private var viewModel: HomeAddressViewModel

    init(viewModel: HomeAddressViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.s24) {

                VStack(alignment: .leading, spacing: Spacing.s16) {
                    Text("Your Address")
                        .carelyText(style: .heading2, weight: .bold)
                        .foregroundColor(.primaryFont)

                    Text("We need your address to coordinate care services in your area.")
                        .carelyText(style: .bodyRegular, weight: .regular)
                        .foregroundColor(.secondaryFont)
                }

                useCurrentLocationButton

                VStack(spacing: Spacing.s16) {
                    CarelyTextField(
                        label: "Country",
                        placeholder: "e.g. Egypt",
                        text: $viewModel.country,
                        trailingIcon: "globe",
                        onTrailingIconTap: {}
                    )

                    HStack(spacing: Spacing.s12) {
                        CarelyTextField(label: "City", placeholder: "e.g. Cairo", text: $viewModel.city)
                        CarelyTextField(label: "Area", placeholder: "e.g. Nasr City", text: $viewModel.area)
                    }

                    CarelyTextField(label: "Street Name", placeholder: "Enter your street address", text: $viewModel.streetName)

                    HStack(spacing: Spacing.s12) {
                        CarelyTextField(label: "Building (optional)", placeholder: "e.g. Block A", text: $viewModel.building)
                        CarelyTextField(label: "Apt No. (optional)", placeholder: "e.g. 4B", text: $viewModel.apartment)
                    }

                    Button(action: { viewModel.openMapPicker() }) {
                        ZStack {
                            Image("map-image")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 150)
                                .clipped()
                                .cornerRadius(12)

                            Image(systemName: "mappin.circle.fill")
                                .resizable()
                                .frame(width: 36, height: 36)
                                .foregroundColor(.brandPrimary)
                                .background(Circle().fill(Color.white).frame(width: 24, height: 24))
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(Spacing.s16)
                .background(.background)
                .cornerRadius(20)

                if let errorMessage = viewModel.locationErrorMessage {
                    InfoBannerView(text: errorMessage, iconName: "exclamationmark.triangle.fill")
                }

                InfoBannerView(
                    text: "Accurate addresses help our healthcare professionals reach you faster during emergencies.",
                    iconName: "info.circle"
                )

                Spacer()

                VStack(spacing: Spacing.s12) {
                    PrimaryButton(title: "Finish Setup") {
                        viewModel.finishSetupTapped()
                    }

                    SecondaryButton(title: "Back") {
                        viewModel.backTapped()
                    }
                }
            }
            .padding(Spacing.s16)
        }
        .background(Color.backGround)
        .sheet(isPresented: $viewModel.isMapPickerPresented) {
            AddressMapPickerBottomSheet(viewModel: viewModel.mapPickerViewModel)
                .presentationDetents([.fraction(0.85), .large])
                .presentationDragIndicator(.visible)
        }
    }

    // MARK: - Use Current Location Button

    private var useCurrentLocationButton: some View {
        Button(action: { viewModel.useCurrentLocationTapped() }) {
            HStack(spacing: Spacing.s16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.brandPrimary.opacity(0.1))
                        .frame(width: 48, height: 48)

                    if viewModel.isLocatingCurrentLocation {
                        ProgressView()
                            .tint(.brandPrimary)
                    } else {
                        Image(systemName: "location.fill")
                            .foregroundColor(.brandPrimary)
                    }
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Use current location")
                        .carelyText(style: .bodyRegular, weight: .bold)
                        .foregroundColor(.primaryFont)
                    Text("Finds your exact location automatically")
                        .carelyText(style: .bodySmall, weight: .regular)
                        .foregroundColor(.secondaryFont)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondaryFont)
            }
            .padding(Spacing.s16)
            .background(Color.backGround)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
        }
        .disabled(viewModel.isLocatingCurrentLocation)
    }
}

#Preview {
    let diContainer = DIContainer()
    ProfileSetupCoordinatorView(
        coordinator: diContainer.makeProfileSetupCoordinator(),
        container: diContainer
    ) {}
}
