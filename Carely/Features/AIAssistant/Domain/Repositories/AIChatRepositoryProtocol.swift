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
    case unknown

    var errorDescription: String? {
        switch self {
        case .network:
            return "Something went wrong. Please check your connection and try again."
        case .unknown:
            return "Something went wrong. Please try again."
        }
    }
}

// MARK: - AIChatRepositoryProtocol

protocol AIChatRepositoryProtocol {
    func sendMessage(_ message: String) async throws -> AIChatReply
}
