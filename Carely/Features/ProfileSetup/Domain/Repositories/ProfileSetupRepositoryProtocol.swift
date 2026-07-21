//
//  HomeAddressRepositoryProtocol.swift
//  Carely
//

import Foundation
import CoreLocation

protocol HomeAddressRepositoryProtocol {
    func updateSearchQuery(_ query: String)
    func setSearchSuggestionsHandler(_ handler: @escaping ([SearchSuggestion]) -> Void)
    func resolveLocation(for suggestion: SearchSuggestion) async throws -> CLLocationCoordinate2D
    func reverseGeocode(latitude: Double, longitude: Double) async throws -> AddressSelection
    func geocodeCountry(_ country: String) async throws -> CLLocationCoordinate2D?
    func currentCoordinateIfAuthorized() async -> CLLocationCoordinate2D?
    func requestCurrentLocationAddress() async throws -> AddressSelection
}
