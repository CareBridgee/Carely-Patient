//
//  GeocodingService.swift
//  Carely
//

import Foundation
import CoreLocation

protocol GeocodingServiceProtocol {
    func geocodeAddressString(_ addressString: String) async throws -> [CLPlacemark]
    func reverseGeocodeLocation(_ location: CLLocation) async throws -> [CLPlacemark]
}

final class GeocodingService: GeocodingServiceProtocol {
    
    private let geocoder = CLGeocoder()
    
    func geocodeAddressString(_ addressString: String) async throws -> [CLPlacemark] {
        return try await geocoder.geocodeAddressString(addressString)
    }
    
    func reverseGeocodeLocation(_ location: CLLocation) async throws -> [CLPlacemark] {
        return try await geocoder.reverseGeocodeLocation(location)
    }
}
