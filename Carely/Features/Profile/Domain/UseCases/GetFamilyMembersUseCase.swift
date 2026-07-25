//
//  GetFamilyMembersUseCase.swift
//  Carely
//
//  Created by Mina on 25/07/2026.
//

import Foundation

protocol GetFamilyMembersUseCaseProtocol {
    func execute() async throws -> [FamilyMember]
}

final class GetFamilyMembersUseCase: GetFamilyMembersUseCaseProtocol {
    private let repository: ProfileRepositoryProtocol

    init(repository: ProfileRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> [FamilyMember] {
        try await repository.fetchFamilyMembers()
    }
}
