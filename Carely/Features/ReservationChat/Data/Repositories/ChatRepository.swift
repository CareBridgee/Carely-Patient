//
//  ChatRepository.swift
//  Carely
//

import Foundation

protocol ChatRepositoryProtocol {
    var onMessageReceived: ((ChatMessageResponse) -> Void)? { get set }
    var onError: ((String) -> Void)? { get set }
    
    func connectSocket()
    func disconnectSocket()
    
    func fetchHistoricalMessages(reservationId: String) async throws -> [ChatMessageResponse]
    func sendMessage(reservationId: String, content: String, isSocketConnected: Bool) async throws
}

final class ChatRepository: ChatRepositoryProtocol {
    var onMessageReceived: ((ChatMessageResponse) -> Void)?
    var onError: ((String) -> Void)?
    
    private var hubService: ChatHubServiceProtocol
    private let networkService: ChatNetworkServiceProtocol
    
    init(hubService: ChatHubServiceProtocol, networkService: ChatNetworkServiceProtocol) {
        self.hubService = hubService
        self.networkService = networkService
        
        self.hubService.onMessageReceived = { [weak self] message in
            self?.onMessageReceived?(message)
        }
        
        self.hubService.onError = { [weak self] error in
            self?.onError?(error)
        }
    }
    
    func connectSocket() {
        hubService.connect()
    }
    
    func disconnectSocket() {
        hubService.disconnect()
    }
    
    func fetchHistoricalMessages(reservationId: String) async throws -> [ChatMessageResponse] {
        return try await networkService.getHistoricalMessages(reservationId: reservationId)
    }
    
    func sendMessage(reservationId: String, content: String, isSocketConnected: Bool) async throws {
        if isSocketConnected {
            hubService.sendMessage(content: content)
        } else {
            // Fallback to REST
            let message = try await networkService.sendMessage(reservationId: reservationId, content: content)
            self.onMessageReceived?(message)
        }
    }
}
