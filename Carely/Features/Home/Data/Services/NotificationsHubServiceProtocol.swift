//
//  NotificationsHubServiceProtocol.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 04/08/2026.
//


import Foundation

protocol NotificationsHubServiceProtocol {
    var onNotificationReceived: ((NotificationResponseDTO) -> Void)? { get set }
    func connectAndSubscribe()
    func disconnect()
}

final class NotificationsSocketDataSource: NotificationsHubServiceProtocol {
    var onNotificationReceived: ((NotificationResponseDTO) -> Void)?

    private let socketClient: SocketClientProtocol
    private let decoder = JSONDecoder()
    private let destination = "/user/queue/notifications"

    init(socketClient: SocketClientProtocol) {
        self.socketClient = socketClient
        self.setupSocketEvents()
    }

    private func setupSocketEvents() {
            let key = "Notifications"
            
            socketClient.onConnectedListeners[key] = { [weak self] in
                guard let self = self else { return }
                self.socketClient.subscribe(to: self.destination)
                self.socketClient.subscribe(to: "/user/queue/errors")
            }

            socketClient.onMessageReceivedListeners[key] = { [weak self] receivedDestination, body in
                guard let self = self else { return }
                
                if receivedDestination.contains("/queue/notifications") {
                    // 1. Handle the normal UI notification (show banner, badge, etc.)
                    self.handleMessage(body: body)
                    
                    // 👇 2. THE NEW GLOBAL TRIGGER: Check if this notification is a cancellation
                    if body.contains("REQUEST_CANCELLED") || body.contains("CANCELLED") || body.contains("REJECTED") {
                        Task {
                            // This will instantly check the backend and refund the wallet if needed!
                            await RefundRecoveryService.shared?.processPendingRefunds()
                        }
                    }
                    
                } else if receivedDestination.contains("/queue/errors") {
                    print("[Socket Error Payload] Received error from backend: \(body)")
                }
            }
        }

    func connectAndSubscribe() {
        socketClient.connect()
    }

    func disconnect() {
        socketClient.unsubscribe(from: destination)
        // بنعمل unsubscribe بس، مش disconnect للـ Socket كله عشان ده Shared!
    }

    private func handleMessage(body: String) {
        guard let data = body.data(using: .utf8) else { return }
        do {
            let notification = try decoder.decode(NotificationResponseDTO.self, from: data)
            DispatchQueue.main.async {
                self.onNotificationReceived?(notification)
            }
        } catch {
            print("[NotificationsSocket] Error decoding message: \(error)")
        }
    }
}
