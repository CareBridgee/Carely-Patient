//
//  AIChatRepositoryImpl.swift
//  Carely
//

import Foundation

final class AIChatRepositoryImpl: AIChatRepositoryProtocol {
    private let service: AIChatServiceProtocol

    init(service: AIChatServiceProtocol) {
        self.service = service
    }

    func sendMessage(_ message: String) async throws -> AIChatReply {
        do {
            let dto = try await service.sendMessage(message)
            return AIChatReply(text: dto.reply)
        } catch let error as NetworkError {
            switch error {
            case .noInternetConnection, .timeout:
                throw AIChatError.network
            case .unauthorized, .sessionExpired:
                throw error
            default:
                throw AIChatError.network
            }
        } catch {
            throw AIChatError.unknown
        }
    }
}
