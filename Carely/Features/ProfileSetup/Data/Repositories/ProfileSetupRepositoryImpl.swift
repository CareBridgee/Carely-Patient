//
//  HomeAddressRepositoryImpl.swift
//  Carely
//

import Foundation
import CoreLocation
import Combine

final class HomeAddressRepositoryImpl: HomeAddressRepositoryProtocol {

    // MARK: - Services (private implementation details)

    private let searchService: MapSearchService
    private let geocodingService: GeocodingService
    private let locationProvider: CurrentLocationProviderProtocol

    // MARK: - Internal Combine pipeline (never leaks past this boundary)

    private var cancellable: AnyCancellable?
    private var suggestionsHandler: (([SearchSuggestion]) -> Void)?

    // MARK: - Init

    init(
        searchService: MapSearchService,
        geocodingService: GeocodingService,
        locationProvider: CurrentLocationProviderProtocol
    ) {
        self.searchService = searchService
        self.geocodingService = geocodingService
        self.locationProvider = locationProvider
    }

    // MARK: - Search

    func updateSearchQuery(_ query: String) {
        searchService.updateSearchQuery(query)
    }

    func setSearchSuggestionsHandler(_ handler: @escaping ([SearchSuggestion]) -> Void) {
        suggestionsHandler = handler
        cancellable = searchService.searchSuggestions()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] suggestions in
                self?.suggestionsHandler?(suggestions)
            }
    }

    func resolveLocation(for suggestion: SearchSuggestion) async throws -> CLLocationCoordinate2D {
        return try await searchService.resolveLocation(for: suggestion)
    }

    // MARK: - Geocoding

    func reverseGeocode(latitude: Double, longitude: Double) async throws -> AddressSelection {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let placemarks = try await geocodingService.reverseGeocodeLocation(location)

        guard let placemark = placemarks.first else {
            throw HomeAddressRepositoryError.reverseGeocodeFailed
        }

        let country = placemark.country ?? ""
        let city = placemark.locality ?? ""
        let area = placemark.subLocality ?? placemark.administrativeArea ?? ""
        let street = [placemark.thoroughfare, placemark.subThoroughfare]
            .compactMap { $0 }
            .joined(separator: " ")

        return AddressSelection(
            country: country,
            city: city,
            area: area,
            street: street,
            coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        )
    }

    func geocodeCountry(_ country: String) async throws -> CLLocationCoordinate2D? {
        let placemarks = try await geocodingService.geocodeAddressString(country)
        return placemarks.first?.location?.coordinate
    }

    // MARK: - Location

    func currentCoordinateIfAuthorized() async -> CLLocationCoordinate2D? {
        return await locationProvider.currentCoordinateIfAuthorized()
    }

    func requestCurrentLocationAddress() async throws -> AddressSelection {
        guard let coordinate = await locationProvider.requestCurrentCoordinate() else {
            throw HomeAddressRepositoryError.locationUnavailable
        }
        return try await reverseGeocode(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}

// MARK: - Errors

enum HomeAddressRepositoryError: LocalizedError {
    case reverseGeocodeFailed
    case locationUnavailable

    var errorDescription: String? {
        switch self {
        case .reverseGeocodeFailed:
            return "Couldn't determine an address for this location."
        case .locationUnavailable:
            return "Unable to retrieve your current location. Please check your location settings."
        }
    }
}
