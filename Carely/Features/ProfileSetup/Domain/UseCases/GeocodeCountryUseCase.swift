//
//  GeocodeCountryUseCase.swift
//  Carely
//

import Foundation
import CoreLocation

final class GeocodeCountryUseCase {

    private let repository: ProfileSetupRepositoryProtocol

    init(repository: ProfileSetupRepositoryProtocol) {
        self.repository = repository
    }

    func execute(country: String) async throws -> CLLocationCoordinate2D? {
        return try await repository.geocodeCountry(country)
    }
}
