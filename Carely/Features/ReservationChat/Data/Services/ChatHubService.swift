//
//  ChatHubService.swift
//  Carely
//

import Foundation

protocol ChatHubServiceProtocol {
    var onMessageReceived: ((ChatMessageResponse) -> Void)? { get set }
    var onError: ((String) -> Void)? { get set }
    
    func connect()
    func disconnect()
    func sendMessage(content: String)
}

final class ChatHubService: ChatHubServiceProtocol {
    var onMessageReceived: ((ChatMessageResponse) -> Void)?
    var onError: ((String) -> Void)?
    
    private let socketClient: SocketClientProtocol
    private let reservationId: String
    private let decoder = JSONDecoder()
    
    private let topicDestination: String
    private let sendDestination: String
    private let listenerKey: String
    
    init(socketClient: SocketClientProtocol, reservationId: String) {
        self.socketClient = socketClient
        self.reservationId = reservationId
        self.topicDestination = "/topic/chat/\(reservationId)"
        self.sendDestination = "/app/chat/\(reservationId)/send"
        self.listenerKey = "Chat_\(reservationId)_\(UUID().uuidString)"
        
        setupSocketEvents()
    }
    
    private func setupSocketEvents() {
        socketClient.onConnectedListeners[listenerKey] = { [weak self] in
            guard let self = self else { return }
            self.socketClient.subscribe(to: self.topicDestination)
        }
        
        socketClient.onMessageReceivedListeners[listenerKey] = { [weak self] destination, body in
            guard let self = self else { return }
            if destination == self.topicDestination {
                self.handleMessage(body: body)
            }
        }
        
        socketClient.onErrorListeners[listenerKey] = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.onError?(errorMessage)
            }
        }
    }
    
    func connect() {
        socketClient.connect()
    }
    
    func disconnect() {
        socketClient.unsubscribe(from: topicDestination)
        socketClient.onConnectedListeners.removeValue(forKey: listenerKey)
        socketClient.onMessageReceivedListeners.removeValue(forKey: listenerKey)
        socketClient.onErrorListeners.removeValue(forKey: listenerKey)
    }
    
    func sendMessage(content: String) {
        let request = ChatMessageRequest(content: content)
        do {
            let data = try JSONEncoder().encode(request)
            if let stringBody = String(data: data, encoding: .utf8) {
                socketClient.send(to: sendDestination, body: stringBody)
            }
        } catch {
            DispatchQueue.main.async {
                self.onError?("Failed to encode message")
            }
        }
    }
    
    private func handleMessage(body: String) {
        guard let data = body.data(using: .utf8) else { return }
        do {
            let message = try decoder.decode(ChatMessageResponse.self, from: data)
            DispatchQueue.main.async {
                self.onMessageReceived?(message)
            }
        } catch {
            print("[ChatHubService] Error decoding message: \(error)")
        }
    }
}
