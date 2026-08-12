//
//  ResetAIChatUseCase.swift
//  Carely
//
//  Created by Mohamed Ayman on 08/08/2026.
//

import Foundation

// MARK: - Protocol

protocol ResetAIChatUseCaseProtocol {
    func execute(profileId: String) async throws
}

// MARK: - Implementation

final class ResetAIChatUseCase: ResetAIChatUseCaseProtocol {
    private let repository: AIChatRepositoryProtocol

    init(repository: AIChatRepositoryProtocol) {
        self.repository = repository
    }

    func execute(profileId: String) async throws {
        try await repository.resetChat(profileId: profileId)
    }
}
