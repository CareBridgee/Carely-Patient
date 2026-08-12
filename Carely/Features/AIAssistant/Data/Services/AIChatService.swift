//
//  AIChatService.swift
//  Carely
//
//  Created by Mohamed Ayman on 31/07/2026.
//

import Foundation

// MARK: - Protocol

protocol AIChatServiceProtocol {
    func sendMessage(profileId: String, message: String) async throws -> ChatTurnResponseDTO
    func resetChat(profileId: String) async throws
}

// MARK: - Implementation

final class AIChatServiceImpl: AIChatServiceProtocol {
    private let networkClient: NetworkClientProtocol
    var useLogs: Bool = false

    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }

    func sendMessage(profileId: String, message: String) async throws -> ChatTurnResponseDTO {
        if useLogs { print("AIChatService: sending message to /api/v1/chat for profile: \(profileId)") }
        return try await networkClient.request(AIChatEndpoint.sendMessage(profileId: profileId, message: message))
    }

    func resetChat(profileId: String) async throws {
        if useLogs { print("AIChatService: resetting chat on /api/v1/chat/reset for profile: \(profileId)") }
        try await networkClient.requestWithoutResponse(AIChatEndpoint.resetChat(profileId: profileId))
    }
}

