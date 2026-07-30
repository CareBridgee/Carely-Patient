//
//  HomeAddressViewModel.swift
//  Carely
//
//  Created by Mohamed Ayman on 19/07/2026.
//
import Foundation

@MainActor
final class HomeAddressViewModel: ObservableObject {

    @Published var country: String
    @Published var city: String
    @Published var area: String
    @Published var streetName: String
    @Published var building: String
    @Published var apartment: String

    @Published private(set) var selectedLatitude: Double?
    @Published private(set) var selectedLongitude: Double?

    @Published var isMapPickerPresented = false
    @Published private(set) var isLocatingCurrentLocation = false
    @Published private(set) var locationErrorMessage: String?
    
    // NEW: Network State
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var showError: Bool = false

    let mapPickerViewModel: AddressMapPickerViewModel

    private let getCurrentLocationAddressUseCase: GetCurrentLocationAddressUseCase
    private let getProfileIdUseCase: GetDefaultProfileIdUseCase
    private let saveAddressUseCase: SaveHomeAddressUseCase
    private let onFinishSetup: (HomeAddress) -> Void
    private let onBackTapped: (HomeAddress) -> Void

    init(
        initialAddress: HomeAddress?,
        mapPickerViewModel: AddressMapPickerViewModel,
        getCurrentLocationAddressUseCase: GetCurrentLocationAddressUseCase,
        getProfileIdUseCase: GetDefaultProfileIdUseCase,
        saveAddressUseCase: SaveHomeAddressUseCase,
        onFinishSetup: @escaping (HomeAddress) -> Void,
        onBackTapped: @escaping (HomeAddress) -> Void
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
        self.getProfileIdUseCase = getProfileIdUseCase
        self.saveAddressUseCase = saveAddressUseCase
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
    private var address: HomeAddress {
            HomeAddress(country: country.trimmed, city: city.trimmed, area: area.trimmed, streetName: streetName.trimmed, building: building.trimmed, apartment: apartment.trimmed, latitude: selectedLatitude, longitude: selectedLongitude)
        }

        var isEmpty: Bool {
            country.trimmed.isEmpty && city.trimmed.isEmpty && area.trimmed.isEmpty && streetName.trimmed.isEmpty && building.trimmed.isEmpty && apartment.trimmed.isEmpty
        }

        var isValid: Bool {
            !country.trimmed.isEmpty && !city.trimmed.isEmpty && !streetName.trimmed.isEmpty
        }

        func backTapped() {
            onBackTapped(address)
        }

        func finishSetupTapped() {
            // MARK: - SKIP LOGIC
            if isEmpty {
                onFinishSetup(address)
                return
            }

            // MARK: - VALIDATION LOGIC
            guard isValid else {
                self.errorMessage = "Please fill in all required fields (Country, City, Street)."
                self.showError = true
                return
            }

            guard NetworkMonitor.shared.isConnected else {
                self.errorMessage = "No internet connection. Please check your network."
                self.showError = true
                return
            }

            isLoading = true
            errorMessage = nil

            Task {
                do {
                    let profileId = try await getProfileIdUseCase.execute()
                    try await saveAddressUseCase.execute(profileId: profileId, address: address)
                    
                    self.isLoading = false
                    self.onFinishSetup(address)
                    
                } catch {
                    self.isLoading = false
                    self.errorMessage = error.localizedDescription
                    self.showError = true
                }
            }
        }
    }

    private extension String {
        var trimmed: String { trimmingCharacters(in: .whitespacesAndNewlines) }
    }
