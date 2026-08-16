//
//  GetActiveVisitUseCase.swift
//  Carely
//
//  Created by Mona Zarea on 15/08/2026.
//

import Foundation

protocol GetActiveVisitUseCaseProtocol {
    func execute() async throws -> ConfirmedOffer?
}

final class GetActiveVisitUseCase: GetActiveVisitUseCaseProtocol {
    private let repository: HomeRepositoryProtocol

    init(repository: HomeRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> ConfirmedOffer? {
        try await repository.fetchActiveVisit()
    }
}
