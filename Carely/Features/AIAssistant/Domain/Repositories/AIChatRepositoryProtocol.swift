//
//  AIChatRepositoryProtocol.swift
//  Carely
//
//  Created by Mohamed Ayman on 31/07/2026.
//

import Foundation

// MARK: - AIChatError

enum AIChatError: LocalizedError, Equatable {
    case network
    case rateLimited
    case serviceUnavailable
    case validation(String)
    case server(String)
    case unknown

    var errorDescription: String? {
        switch self {
        case .network:
            return "No internet connection. Please check your network and try again."
        case .rateLimited:
            return "Too many requests. Please wait a moment and try again."
        case .serviceUnavailable:
            return "AI Assistant is temporarily unavailable. Please try again in a few moments."
        case .validation(let message):
            return message
        case .server(let message):
            return message
        case .unknown:
            return "Something went wrong. Please try again."
        }
    }
}

// MARK: - AIChatRepositoryProtocol

protocol AIChatRepositoryProtocol {
    func sendMessage(profileId: String, message: String) async throws -> ChatTurnResponse
    func resetChat(profileId: String) async throws
}

