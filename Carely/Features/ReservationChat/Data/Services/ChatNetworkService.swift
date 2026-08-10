//
//  ChatNetworkService.swift
//  Carely
//

import Foundation
import Alamofire

enum ReservationChatEndpoint: Endpoint {
    case getHistoricalMessages(reservationId: String)
    case sendMessage(reservationId: String, content: String)
    
    var path: String {
        switch self {
        case .getHistoricalMessages(let id), .sendMessage(let id, _):
            return "/api/v1/reservations/\(id)/messages"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getHistoricalMessages:
            return .get
        case .sendMessage:
            return .post
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .getHistoricalMessages:
            return nil
        case .sendMessage(_, let content):
            return ["content": content]
        }
    }
}

protocol ChatNetworkServiceProtocol {
    func getHistoricalMessages(reservationId: String) async throws -> [ChatMessageResponse]
    func sendMessage(reservationId: String, content: String) async throws -> ChatMessageResponse
}

final class ChatNetworkService: ChatNetworkServiceProtocol {
    private let networkClient: NetworkClientProtocol
    
    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }
    
    func getHistoricalMessages(reservationId: String) async throws -> [ChatMessageResponse] {
        return try await networkClient.request(ReservationChatEndpoint.getHistoricalMessages(reservationId: reservationId))
    }
    
    func sendMessage(reservationId: String, content: String) async throws -> ChatMessageResponse {
        return try await networkClient.request(ReservationChatEndpoint.sendMessage(reservationId: reservationId, content: content))
    }
}
