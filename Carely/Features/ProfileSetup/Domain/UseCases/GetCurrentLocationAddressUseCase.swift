//
//  GetCurrentLocationAddressUseCase.swift
//  Carely
//

import Foundation

final class GetCurrentLocationAddressUseCase {

    private let repository: ProfileSetupRepositoryProtocol

    init(repository: ProfileSetupRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> AddressSelection {
        return try await repository.requestCurrentLocationAddress()
    }
}
