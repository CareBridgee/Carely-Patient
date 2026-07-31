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
    @Published private(set) var currentUser: User?

    private let tokenStore: TokenStoring
    private let userDefaults: UserDefaults
    private let userKey = "com.carely.currentUser"

    init(tokenStore: TokenStoring, userDefaults: UserDefaults = .standard) {
        self.tokenStore = tokenStore
        self.userDefaults = userDefaults
        
        if tokenStore.getAccessToken() != nil {
            self.state = .loggedIn
            if let data = userDefaults.data(forKey: userKey),
               let user = try? JSONDecoder().decode(User.self, from: data) {
                self.currentUser = user
            } else {
                self.currentUser = nil
            }
        } else {
            self.state = .loggedOut
            self.currentUser = nil
        }
    }

    func setLoggedIn(user: User) {
        state = .loggedIn
        updateUser(user)
    }

    func setLoggedOut() {
        state = .loggedOut
        clearUser()
    }

    // Call this whenever the user updates their profile remotely
    func updateUser(_ user: User) {
        self.currentUser = user
        if let data = try? JSONEncoder().encode(user) {
            userDefaults.set(data, forKey: userKey)
        }
    }

    private func clearUser() {
        self.currentUser = nil
        userDefaults.removeObject(forKey: userKey)
    }

    nonisolated func sessionDidExpire() {
        Task { @MainActor in
            self.state = .expired
            // Keeping the user data might be useful for re-login context,
            // but you can call self.clearUser() here if security demands it.
        }
    }
}
