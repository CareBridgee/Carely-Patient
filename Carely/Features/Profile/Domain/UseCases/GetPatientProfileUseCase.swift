//
//  GetPatientProfileUseCase.swift
//  Carely
//
//  Created by Mina on 25/07/2026.
//

import Foundation

protocol GetPatientProfileUseCaseProtocol {
    func execute() async throws -> PatientProfile
}

final class GetPatientProfileUseCase: GetPatientProfileUseCaseProtocol {
    private let repository: ProfileRepositoryProtocol

    init(repository: ProfileRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> PatientProfile {
        try await repository.fetchPatientProfile()
    }
}
