//
//  SocketClientProtocol.swift
//  Carely
//
//  Created by Mohamed Ayman on 03/08/2026.
//

import Foundation

protocol SocketClientProtocol: AnyObject {
    var isConnected: Bool { get }

    func connect()
    func disconnect()
    func subscribe(to destination: String)
    func unsubscribe(from destination: String)
    func send(to destination: String, body: String, headers: [String: String]?)

    var onConnectedListeners: [String: () -> Void] { get set }
        var onDisconnectedListeners: [String: () -> Void] { get set }
        var onMessageReceivedListeners: [String: (_ destination: String, _ body: String) -> Void] { get set }
        var onErrorListeners: [String: (_ description: String) -> Void] { get set }
}
