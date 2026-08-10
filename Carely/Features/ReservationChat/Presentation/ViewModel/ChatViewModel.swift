//
//  ChatViewModel.swift
//  Carely
//

import Foundation
import Combine

@MainActor
final class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessageResponse] = []
    @Published var newMessageText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let repository: ChatRepositoryProtocol
    private let reservationId: String
    let currentUserId: String
    
    private var isSocketConnected: Bool = false
    
    init(repository: ChatRepositoryProtocol, reservationId: String, currentUserId: String) {
        self.repository = repository
        self.reservationId = reservationId
        self.currentUserId = currentUserId
        
        setupRepositoryListeners()
    }
    
    private func setupRepositoryListeners() {
        var mutableRepo = repository
        
        mutableRepo.onMessageReceived = { [weak self] message in
            guard let self = self else { return }
            if !self.messages.contains(where: { $0.id == message.id }) {
                self.messages.append(message)
            }
        }
        
        mutableRepo.onError = { [weak self] error in
            self?.errorMessage = error
        }
    }
    
    func onAppear() {
        loadHistoricalMessages()
        connectSocket()
    }
    
    func onDisappear() {
        disconnectSocket()
    }
    
    private func loadHistoricalMessages() {
        isLoading = true
        Task {
            do {
                let history = try await repository.fetchHistoricalMessages(reservationId: reservationId)
                self.messages = history
            } catch {
                self.errorMessage = "Failed to load history: \(error.localizedDescription)"
            }
            self.isLoading = false
        }
    }
    
    private func connectSocket() {
        repository.connectSocket()
        isSocketConnected = true
    }
    
    private func disconnectSocket() {
        repository.disconnectSocket()
        isSocketConnected = false
    }
    
    func sendMessage() {
        let content = newMessageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !content.isEmpty else { return }
        
        newMessageText = ""
        
        Task {
            do {
                try await repository.sendMessage(reservationId: reservationId, content: content, isSocketConnected: isSocketConnected)
            } catch {
                self.errorMessage = "Failed to send message: \(error.localizedDescription)"
            }
        }
    }
}
