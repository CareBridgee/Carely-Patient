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
    func send(to destination: String, body: String)

    var onConnected: (() -> Void)? { get set }
    var onDisconnected: (() -> Void)? { get set }
    var onMessageReceived: ((_ destination: String, _ body: String) -> Void)? { get set }
    var onError: ((_ description: String) -> Void)? { get set }
}
