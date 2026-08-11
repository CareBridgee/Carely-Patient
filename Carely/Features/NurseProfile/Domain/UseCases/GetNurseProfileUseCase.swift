//
//  GetNurseProfileUseCase.swift
//  Carely
//
//  Created by Mina on 08/08/2026.
//

import Foundation

protocol GetNurseProfileUseCaseProtocol {
    func execute(nurseId: String) async throws -> NurseDetails
}

struct GetNurseProfileUseCase: GetNurseProfileUseCaseProtocol {
    private let repository: NurseRepositoryProtocol

    init(repository: NurseRepositoryProtocol) {
        self.repository = repository
    }

    func execute(nurseId: String) async throws -> NurseDetails {
        try await repository.getNurseProfile(id: nurseId)
    }
}
