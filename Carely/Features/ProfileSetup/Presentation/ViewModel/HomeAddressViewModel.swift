//
//  HomeAddressViewModel.swift
//  Carely
//
//  Created by Mohamed Ayman on 19/07/2026.
//

import Foundation

@MainActor
final class HomeAddressViewModel: ObservableObject {

    // MARK: - Manual Entry Fields

    @Published var country: String
    @Published var city: String
    @Published var area: String
    @Published var streetName: String
    @Published var building: String
    @Published var apartment: String

    // MARK: - Selected Coordinate

    @Published private(set) var selectedLatitude: Double?
    @Published private(set) var selectedLongitude: Double?

    // MARK: - Map Picker State

    @Published var isMapPickerPresented = false

    // MARK: - Current Location State

    @Published private(set) var isLocatingCurrentLocation = false
    @Published private(set) var locationErrorMessage: String?

    // MARK: - Child ViewModel (owned, stable for the lifetime of this VM)

    let mapPickerViewModel: AddressMapPickerViewModel

    // MARK: - Use Cases

    private let getCurrentLocationAddressUseCase: GetCurrentLocationAddressUseCase

    // MARK: - Coordinator Callbacks

    private let onFinishSetup: (HomeAddress) -> Void
    private let onBackTapped: () -> Void

    // MARK: - Init

    init(
        initialAddress: HomeAddress?,
        mapPickerViewModel: AddressMapPickerViewModel,
        getCurrentLocationAddressUseCase: GetCurrentLocationAddressUseCase,
        onFinishSetup: @escaping (HomeAddress) -> Void,
        onBackTapped: @escaping () -> Void
    ) {
        self.country = initialAddress?.country ?? ""
        self.city = initialAddress?.city ?? ""
        self.area = initialAddress?.area ?? ""
        self.streetName = initialAddress?.streetName ?? ""
        self.building = initialAddress?.building ?? ""
        self.apartment = initialAddress?.apartment ?? ""
        self.selectedLatitude = initialAddress?.latitude
        self.selectedLongitude = initialAddress?.longitude
        self.mapPickerViewModel = mapPickerViewModel
        self.getCurrentLocationAddressUseCase = getCurrentLocationAddressUseCase
        self.onFinishSetup = onFinishSetup
        self.onBackTapped = onBackTapped
    }

    // MARK: - Map Picker

    func openMapPicker() {
        locationErrorMessage = nil
        mapPickerViewModel.prepareForPresentation(
            country: country,
            latitude: selectedLatitude,
            longitude: selectedLongitude
        )
        isMapPickerPresented = true
    }

    func closeMapPicker() {
        isMapPickerPresented = false
    }

    func handleAddressSelection(_ selection: AddressSelection) {
        country = selection.country
        city = selection.city
        area = selection.area
        streetName = selection.street
        selectedLatitude = selection.coordinate.latitude
        selectedLongitude = selection.coordinate.longitude
        closeMapPicker()
    }

    // MARK: - Use Current Location

    func useCurrentLocationTapped() {
        guard !isLocatingCurrentLocation else { return }
        locationErrorMessage = nil
        isLocatingCurrentLocation = true

        Task {
            defer { isLocatingCurrentLocation = false }
            do {
                let selection = try await getCurrentLocationAddressUseCase.execute()
                country = selection.country
                city = selection.city
                area = selection.area
                streetName = selection.street
                selectedLatitude = selection.coordinate.latitude
                selectedLongitude = selection.coordinate.longitude
            } catch {
                locationErrorMessage = error.localizedDescription
            }
        }
    }

    // MARK: - Validation

    var isValid: Bool {
        !country.trimmed.isEmpty
            && !city.trimmed.isEmpty
            && !streetName.trimmed.isEmpty
    }

    // MARK: - Actions

    func finishSetupTapped() {
        guard isValid else { return }

        let address = HomeAddress(
            country: country.trimmed,
            city: city.trimmed,
            area: area.trimmed,
            streetName: streetName.trimmed,
            building: building.trimmed,
            apartment: apartment.trimmed,
            latitude: selectedLatitude,
            longitude: selectedLongitude
        )
        onFinishSetup(address)
    }

    func backTapped() {
        onBackTapped()
    }
}

// MARK: - String + Trimmed

private extension String {
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
