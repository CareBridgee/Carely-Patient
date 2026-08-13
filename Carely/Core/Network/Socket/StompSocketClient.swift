//
//  StompSocketClient.swift
//  Carely
//
//  Created by Mohamed Ayman on 03/08/2026.
//

import Foundation
import SwiftStomp

final class StompSocketClient: NSObject {

    static let enableSocketLogs = true

    private let url: URL
    private let tokenStore: TokenStoring

    fileprivate var swiftStomp: SwiftStomp?
    fileprivate var activeSubscriptions: Set<String> = []

    fileprivate let reconnect = ReconnectScheduler()
    fileprivate var isIntentionallyDisconnected = true

    var onConnectedListeners: [String: () -> Void] = [:]
        var onDisconnectedListeners: [String: () -> Void] = [:]
        var onMessageReceivedListeners: [String: (String, String) -> Void] = [:]
        var onErrorListeners: [String: (String) -> Void] = [:]
    var refreshTokenAction: (() async -> Void)?
    var onTokenExpiredOrFailed: (() async -> Bool)?
    init(url: URL, tokenStore: TokenStoring) {
        self.url = url
        self.tokenStore = tokenStore
    }
}

// MARK: - SocketClientProtocol

extension StompSocketClient: SocketClientProtocol {

    var isConnected: Bool {
        swiftStomp?.connectionStatus == .fullyConnected
    }

    func connect() {
            // 1. Prevent duplicate connections if already connected or connecting
            if let stomp = swiftStomp, stomp.connectionStatus == .fullyConnected || stomp.connectionStatus == .connecting {
                log("Already connected or connecting, ignoring duplicate connect call")
                
                if stomp.connectionStatus == .fullyConnected {
                    onConnectedListeners.values.forEach { $0() }
                }
                return
            }
            
            isIntentionallyDisconnected = false
            reconnect.cancel()
            openSocket(attempt: 0)
        }

    func disconnect() {
        isIntentionallyDisconnected = true
        reconnect.cancel()
        log("DISCONNECT")
        swiftStomp?.disconnect(force: false)
        swiftStomp = nil
    }

    func subscribe(to destination: String) {
        activeSubscriptions.insert(destination)
        if isConnected {
            log("SUBSCRIBE \(destination)")
            swiftStomp?.subscribe(to: destination)
        }
    }

    func unsubscribe(from destination: String) {
        activeSubscriptions.remove(destination)
        if isConnected {
            log("UNSUBSCRIBE \(destination)")
            swiftStomp?.unsubscribe(from: destination)
        }
    }

    func send(to destination: String, body: String, headers: [String: String]? = nil) {
        if isConnected {
            log("SEND \(destination)")
            swiftStomp?.send(body: body, to: destination, receiptId: nil, headers: headers)
        }
    }
}

// MARK: - Connection setup

private extension StompSocketClient {
    
    func openSocket(attempt: Int) {
        guard let token = tokenStore.getAccessToken(), !token.isEmpty else {
            log("Auth: no access token found")
            self.onErrorListeners.values.forEach { $0("Missing access token") }
            return
        }
        
        swiftStomp?.disconnect(force: true)
        swiftStomp = nil
        
        log("Connecting to \(url.absoluteString) (attempt \(attempt))")
        
        let stomp = SwiftStomp(
            host: url,
            headers: [
                "Authorization": "Bearer \(token)",
                "accept-version": "1.2,1.1,1.0",
                "heart-beat": "10000,10000"
            ],
            httpConnectionHeaders: [
                "Authorization": "Bearer \(token)",
                "Origin": NetworkConfiguration.baseURL,
                "User-Agent": "Carely-iOS",
                "X-Requested-With": "XMLHttpRequest"
            ]
        )
        
        stomp.delegate = self
        stomp.autoReconnect = false
        
        self.swiftStomp = stomp
        stomp.connect(autoReconnect: false)
    }
    
    func scheduleReconnect() {
            guard !isIntentionallyDisconnected else { return }
            
            reconnect.scheduleNext { [weak self] attempt in
                Task { [weak self] in
                    guard let self = self else { return }
                    
                    if attempt == 1 || attempt == 2 {
                        if let refreshAction = self.onTokenExpiredOrFailed {
                            let success = await refreshAction()
                            if success {
                                print("[Socket] Token refreshed successfully, reconnecting immediately...")
                            }
                        }
                    }
                    
                    await MainActor.run {
                        self.openSocket(attempt: attempt)
                    }
                }
            }
        }
}

// MARK: - SwiftStompDelegate

extension StompSocketClient: SwiftStompDelegate {

    func onConnect(swiftStomp: SwiftStomp, connectType: StompConnectType) {
            switch connectType {
            case .toSocketEndpoint:
                log("WebSocket connected — protocol: stomp")
            case .toStomp:
                log("STOMP CONNECTED")
                reconnect.reset()
                for destination in activeSubscriptions {
                    log("SUBSCRIBE \(destination) (reconnect)")
                    swiftStomp.subscribe(to: destination)
                }
                onConnectedListeners.values.forEach { $0() }
            }
        }

        func onDisconnect(swiftStomp: SwiftStomp, disconnectType: StompDisconnectType) {
            log("WebSocket closed")
            onDisconnectedListeners.values.forEach { $0() }
            scheduleReconnect()
        }

        func onMessageReceived(swiftStomp: SwiftStomp, message: Any?, messageId: String, destination: String, headers: [String: String]) {
            if let stringBody = message as? String {
                log("MESSAGE received on \(destination)")
                onMessageReceivedListeners.values.forEach { $0(destination, stringBody) }
            }
        }

    func onError(swiftStomp: SwiftStomp, briefDescription: String, fullDescription: String?, receiptId: String?, type: StompErrorType) {
            let desc = fullDescription ?? briefDescription
            log("STOMP ERROR — \(desc)")
            self.onErrorListeners.values.forEach { $0(desc) }
        }

    
    func onReceipt(swiftStomp: SwiftStomp, receiptId: String) {
        // Not used
    }

    
}

// MARK: - Logging

private extension StompSocketClient {

    func log(_ message: String) {
        guard Self.enableSocketLogs else { return }
        print("[Socket] \(message)")
    }
}
