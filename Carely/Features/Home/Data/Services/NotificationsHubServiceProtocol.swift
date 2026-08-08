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
            }

            socketClient.onMessageReceivedListeners[key] = { [weak self] receivedDestination, body in
                guard let self = self else { return }
                if receivedDestination.contains("/queue/notifications") {
                    self.handleMessage(body: body)
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
