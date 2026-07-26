//
//  SessionManager.swift
//  Carely
//
//  Created by Mohamed Ayman on 25/07/2026.
//

import Foundation
import Combine

enum SessionState: Equatable {
    case loggedOut
    case loggedIn
    case expired
}

protocol SessionMonitor: Sendable {
    func sessionDidExpire()
}

@MainActor
final class SessionManager: ObservableObject, SessionMonitor {
    @Published private(set) var state: SessionState

    private let tokenStore: TokenStoring

    init(tokenStore: TokenStoring) {
        self.tokenStore = tokenStore
        self.state = tokenStore.getAccessToken() != nil ? .loggedIn : .loggedOut
    }

    func setLoggedIn() {
        state = .loggedIn
    }

    func setLoggedOut() {
        state = .loggedOut
    }

    nonisolated func sessionDidExpire() {
        Task { @MainActor in
            self.state = .expired
        }
    }
}
