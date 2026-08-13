//
//  SendAIChatMessageUseCase.swift
//  Carely
//
//  Created by Mohamed Ayman on 31/07/2026.
//

import Foundation

// MARK: - Protocol

protocol SendAIChatMessageUseCaseProtocol {
    func execute(profileId: String, message: String) async throws -> ChatTurnResponse
}

// MARK: - Implementation

final class SendAIChatMessageUseCase: SendAIChatMessageUseCaseProtocol {
    private let repository: AIChatRepositoryProtocol

    init(repository: AIChatRepositoryProtocol) {
        self.repository = repository
    }

    func execute(profileId: String, message: String) async throws -> ChatTurnResponse {
        try await repository.sendMessage(profileId: profileId, message: message)
    }
}

