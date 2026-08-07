//
//  AIChatService.swift
//  Carely
//
//  Created by Mohamed Ayman on 31/07/2026.
//

import Foundation

// MARK: - Protocol

protocol AIChatServiceProtocol {
    func sendMessage(_ message: String) async throws -> AIChatResponseDTO
}

// MARK: - Implementation

final class AIChatServiceImpl: AIChatServiceProtocol {
    private let networkClient: NetworkClientProtocol
    var useLogs: Bool = false

    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }

    func sendMessage(_ message: String) async throws -> AIChatResponseDTO {
        if useLogs { print("AIChatService: sending message to /api/v1/chat") }
        return try await networkClient.request(AIChatEndpoint.sendMessage(message: message))
    }
}
