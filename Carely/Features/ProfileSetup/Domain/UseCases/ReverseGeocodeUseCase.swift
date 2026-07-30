//
//  ReverseGeocodeUseCase.swift
//  Carely
//

import Foundation

final class ReverseGeocodeUseCase {

    private let repository: ProfileSetupRepositoryProtocol

    init(repository: ProfileSetupRepositoryProtocol) {
        self.repository = repository
    }

    func execute(latitude: Double, longitude: Double) async throws -> AddressSelection {
        return try await repository.reverseGeocode(latitude: latitude, longitude: longitude)
    }
}
