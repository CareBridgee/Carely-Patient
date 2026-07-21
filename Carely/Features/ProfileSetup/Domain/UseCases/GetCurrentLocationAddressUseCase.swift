//
//  GetCurrentLocationAddressUseCase.swift
//  Carely
//

import Foundation

final class GetCurrentLocationAddressUseCase {

    private let repository: HomeAddressRepositoryProtocol

    init(repository: HomeAddressRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> AddressSelection {
        return try await repository.requestCurrentLocationAddress()
    }
}
