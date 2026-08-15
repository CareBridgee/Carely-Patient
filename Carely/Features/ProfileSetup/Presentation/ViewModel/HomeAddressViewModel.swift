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
    private let updateAddressUseCase: UpdateHomeAddressUseCase
    private let fetchAddressUseCase: FetchHomeAddressUseCase?
    private let geocodeAddressUseCase: GeocodeAddressUseCase?
    private(set) var overrideProfileId: String?
    private(set) var isEditingExistingAddress: Bool
    private(set) var initialAddress: HomeAddress?

    private let onFinishSetup: (HomeAddress) -> Void
    private let onBackTapped: (HomeAddress) -> Void
    let showBackButton: Bool
    let continueButtonTitle: String
    let loadingButtonTitle: String
    init(
        initialAddress: HomeAddress?,
        mapPickerViewModel: AddressMapPickerViewModel,
        getCurrentLocationAddressUseCase: GetCurrentLocationAddressUseCase,
        getProfileIdUseCase: GetDefaultProfileIdUseCase,
        saveAddressUseCase: SaveHomeAddressUseCase,
        updateAddressUseCase: UpdateHomeAddressUseCase,
        fetchAddressUseCase: FetchHomeAddressUseCase? = nil,
        geocodeAddressUseCase: GeocodeAddressUseCase? = nil,
        overrideProfileId: String? = nil,
        isEditingExistingAddress: Bool = false,
        onFinishSetup: @escaping (HomeAddress) -> Void,
        onBackTapped: @escaping (HomeAddress) -> Void,
        showBackButton: Bool = true,
        continueButtonTitle: String = "Finish Setup",
        loadingButtonTitle: String = "Finishing..."
    ) {
        self.initialAddress = initialAddress
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
        self.updateAddressUseCase = updateAddressUseCase
        self.fetchAddressUseCase = fetchAddressUseCase
        self.geocodeAddressUseCase = geocodeAddressUseCase
        self.isEditingExistingAddress = isEditingExistingAddress && (initialAddress?.isEmpty == false)
        self.overrideProfileId = overrideProfileId
        self.showBackButton = showBackButton
        self.continueButtonTitle = continueButtonTitle
        self.loadingButtonTitle = loadingButtonTitle
        self.onFinishSetup = onFinishSetup
        self.onBackTapped = onBackTapped

        self.mapPickerViewModel.onConfirm = { [weak self] selection in
            self?.handleAddressSelection(selection)
        }
        self.mapPickerViewModel.onClose = { [weak self] in
            self?.closeMapPicker()
        }
    }

    func applyAddress(_ address: HomeAddress?) {
        if let address, !address.isEmpty {
            self.country = address.country
            self.city = address.city
            self.area = address.area
            self.streetName = address.streetName
            self.building = address.building
            self.apartment = address.apartment
            self.selectedLatitude = address.latitude
            self.selectedLongitude = address.longitude
            self.initialAddress = address
            self.isEditingExistingAddress = true
        } else {
            self.country = ""
            self.city = ""
            self.area = ""
            self.streetName = ""
            self.building = ""
            self.apartment = ""
            self.selectedLatitude = nil
            self.selectedLongitude = nil
            self.initialAddress = HomeAddress()
            self.isEditingExistingAddress = false
        }
    }

    func loadAddress(profileId: String) {
        guard let fetchUseCase = fetchAddressUseCase else { return }
        isLoading = true
        errorMessage = nil

        Task {
            do {
                if let fetched = try await fetchUseCase.execute(profileId: profileId) {
                    self.applyAddress(fetched)
                } else {
                    self.applyAddress(nil)
                }
                self.isLoading = false
            } catch {
                self.isLoading = false
                self.errorMessage = error.localizedDescription
                self.showError = true
            }
        }
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
        if !selection.country.trimmed.isEmpty { country = selection.country }
        if !selection.city.trimmed.isEmpty { city = selection.city }
        if !selection.area.trimmed.isEmpty { area = selection.area }
        if !selection.street.trimmed.isEmpty { streetName = selection.street }
        if !selection.building.trimmed.isEmpty { building = selection.building }
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
                if !selection.country.trimmed.isEmpty { country = selection.country }
                if !selection.city.trimmed.isEmpty { city = selection.city }
                if !selection.area.trimmed.isEmpty { area = selection.area }
                if !selection.street.trimmed.isEmpty { streetName = selection.street }
                if !selection.building.trimmed.isEmpty { building = selection.building }
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
        // MARK: - UNCHANGED OR SKIP LOGIC
        if address == initialAddress || isEmpty {
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
                var targetLatitude = selectedLatitude
                var targetLongitude = selectedLongitude

                // If coordinates are missing, forward geocode the complete address
                if targetLatitude == nil || targetLongitude == nil {
                    let fullAddressString = [streetName, building, area, city, country]
                        .map { $0.trimmed }
                        .filter { !$0.isEmpty }
                        .joined(separator: ", ")

                    if let geocodeUseCase = geocodeAddressUseCase,
                       let coordinate = try await geocodeUseCase.execute(address: fullAddressString) {
                        targetLatitude = coordinate.latitude
                        targetLongitude = coordinate.longitude
                        self.selectedLatitude = coordinate.latitude
                        self.selectedLongitude = coordinate.longitude
                    }
                }

                guard let lat = targetLatitude, let lng = targetLongitude,
                      (-90.0...90.0).contains(lat),
                      (-180.0...180.0).contains(lng) else {
                    self.isLoading = false
                    self.errorMessage = "Unable to determine location coordinates for this address. Please verify your address or select it on the map."
                    self.showError = true
                    return
                }

                let finalAddress = HomeAddress(
                    country: country.trimmed,
                    city: city.trimmed,
                    area: area.trimmed,
                    streetName: streetName.trimmed,
                    building: building.trimmed,
                    apartment: apartment.trimmed,
                    latitude: lat,
                    longitude: lng
                )

                let profileId: String
                if let overrideProfileId {
                    profileId = overrideProfileId
                } else {
                    profileId = try await getProfileIdUseCase.execute()
                }

                if isEditingExistingAddress {
                    do {
                        try await updateAddressUseCase.execute(profileId: profileId, address: finalAddress) 
                    } catch let error as NetworkError {
                        if case .server(404, _) = error {
                            try await saveAddressUseCase.execute(profileId: profileId, address: finalAddress)
                        } else {
                            throw error
                        }
                    }
                } else {
                    try await saveAddressUseCase.execute(profileId: profileId, address: finalAddress)
                }

                self.initialAddress = finalAddress
                self.isEditingExistingAddress = true
                self.isLoading = false
                self.onFinishSetup(finalAddress)
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
