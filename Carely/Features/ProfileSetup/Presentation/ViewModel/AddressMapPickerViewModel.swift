//
//  AddressMapPickerViewModel.swift
//  Carely
//

import Foundation
import MapKit
import SwiftUI

@MainActor
final class AddressMapPickerViewModel: ObservableObject {

    // MARK: - Published State

    @Published var cameraPosition: MapCameraPosition = .region(defaultWorldRegion)
    @Published var searchQuery = ""
    @Published private(set) var searchResults: [SearchSuggestion] = []
    @Published private(set) var selectedCoordinate: CLLocationCoordinate2D?
    @Published private(set) var isResolvingLocation = false
    @Published private(set) var locationErrorMessage: String?

    var canConfirm: Bool { selectedCoordinate != nil && !isResolvingLocation }

    // MARK: - Callbacks (wired by DIContainer after init to avoid circular dependency)

    var onConfirm: ((AddressSelection) -> Void)?
    var onClose: (() -> Void)?

    // MARK: - Use Cases

    private let searchPlacesUseCase: SearchPlacesUseCase
    private let resolveLocationUseCase: ResolveLocationUseCase
    private let reverseGeocodeUseCase: ReverseGeocodeUseCase
    private let geocodeCountryUseCase: GeocodeCountryUseCase
    private let getCurrentLocationCoordinateUseCase: GetCurrentLocationCoordinateUseCase

    // MARK: - Default Regions

    static let defaultWorldRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 20, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100)
    )

    private static let cairoRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 30.0444, longitude: 31.2357),
        span: MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
    )

    // MARK: - Init

    init(
        searchPlacesUseCase: SearchPlacesUseCase,
        resolveLocationUseCase: ResolveLocationUseCase,
        reverseGeocodeUseCase: ReverseGeocodeUseCase,
        geocodeCountryUseCase: GeocodeCountryUseCase,
        getCurrentLocationCoordinateUseCase: GetCurrentLocationCoordinateUseCase
    ) {
        self.searchPlacesUseCase = searchPlacesUseCase
        self.resolveLocationUseCase = resolveLocationUseCase
        self.reverseGeocodeUseCase = reverseGeocodeUseCase
        self.geocodeCountryUseCase = geocodeCountryUseCase
        self.getCurrentLocationCoordinateUseCase = getCurrentLocationCoordinateUseCase

        setupSearchObservation()
    }

    // MARK: - Setup

    private func setupSearchObservation() {
        searchPlacesUseCase.observeSuggestions { [weak self] suggestions in
            Task { @MainActor [weak self] in
                self?.searchResults = suggestions
            }
        }
    }

    // MARK: - Prepare for Presentation

    func prepareForPresentation(country: String, latitude: Double?, longitude: Double?) {
        selectedCoordinate = nil
        searchQuery = ""
        searchResults = []
        locationErrorMessage = nil

        Task {
            await positionInitialCamera(country: country, latitude: latitude, longitude: longitude)
        }
    }

    // MARK: - Camera Positioning

    private func positionInitialCamera(country: String, latitude: Double?, longitude: Double?) async {
        if let latitude, let longitude {
            moveCamera(
                to: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                latitudinalMeters: 800,
                longitudinalMeters: 800
            )
            return
        }

        let trimmedCountry = country.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedCountry.isEmpty,
           let coordinate = try? await geocodeCountryUseCase.execute(country: trimmedCountry) {
            moveCamera(to: coordinate, latitudinalMeters: 1_200_000, longitudinalMeters: 1_200_000)
            return
        }

        if let coordinate = await getCurrentLocationCoordinateUseCase.execute() {
            moveCamera(to: coordinate, latitudinalMeters: 5_000, longitudinalMeters: 5_000)
            return
        }

        cameraPosition = .region(Self.cairoRegion)
    }

    private func moveCamera(
        to coordinate: CLLocationCoordinate2D,
        latitudinalMeters: CLLocationDistance,
        longitudinalMeters: CLLocationDistance
    ) {
        withAnimation {
            cameraPosition = .region(
                MKCoordinateRegion(
                    center: coordinate,
                    latitudinalMeters: latitudinalMeters,
                    longitudinalMeters: longitudinalMeters
                )
            )
        }
    }

    // MARK: - Search

    func updateSearchQuery(_ query: String) {
        searchQuery = query
        selectedCoordinate = nil
        searchPlacesUseCase.updateQuery(query)
    }

    func clearSearch() {
        searchQuery = ""
        selectedCoordinate = nil
        searchResults = []
        searchPlacesUseCase.updateQuery("")
    }

    // MARK: - Search Selection

    func selectSearchResult(_ suggestion: SearchSuggestion) {
        searchQuery = suggestion.title
        searchResults = []
        locationErrorMessage = nil
        selectedCoordinate = nil
        isResolvingLocation = true

        Task {
            defer { isResolvingLocation = false }
            do {
                let coordinate = try await resolveLocationUseCase.execute(for: suggestion)
                selectedCoordinate = coordinate
                moveCamera(to: coordinate, latitudinalMeters: 800, longitudinalMeters: 800)
            } catch {
                locationErrorMessage = "Couldn't locate that place. Try refining your search."
            }
        }
    }

    // MARK: - Map Tap Selection

    func selectCoordinate(_ coordinate: CLLocationCoordinate2D) {
        searchQuery = "" // Clear query since this is a manual tap, not a search result
        searchResults = []
        locationErrorMessage = nil
        selectedCoordinate = coordinate
        moveCamera(to: coordinate, latitudinalMeters: 800, longitudinalMeters: 800)
    }

    // MARK: - Confirm Location

    func confirmSelectedLocation() {
        guard let coordinate = selectedCoordinate else { return }
        locationErrorMessage = nil
        isResolvingLocation = true

        Task {
            defer { isResolvingLocation = false }
            do {
                let selection = try await reverseGeocodeUseCase.execute(
                    latitude: coordinate.latitude,
                    longitude: coordinate.longitude
                )
                onConfirm?(selection)
            } catch {
                locationErrorMessage = "Couldn't determine an address for this location."
            }
        }
    }

    // MARK: - Actions

    func closeMapPicker() {
        onClose?()
    }
}
