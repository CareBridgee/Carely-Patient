//
//  SendAIChatMessageUseCase.swift
//  Carely
//
//  Created by Mohamed Ayman on 31/07/2026.
//

import Foundation

// MARK: - Protocol

protocol SendAIChatMessageUseCaseProtocol {
    func execute(message: String) async throws -> AIChatReply
}

// MARK: - Implementation

final class SendAIChatMessageUseCase: SendAIChatMessageUseCaseProtocol {
    private let repository: AIChatRepositoryProtocol

    init(repository: AIChatRepositoryProtocol) {
        self.repository = repository
    }

    func execute(message: String) async throws -> AIChatReply {
        try await repository.sendMessage(message)
    }
}
