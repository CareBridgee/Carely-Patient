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
    private let hasLaunchedBeforeKey = "com.carely.hasLaunchedBefore"
    
    init(tokenStore: TokenStoring, userDefaults: UserDefaults = .standard) {
        self.tokenStore = tokenStore
        self.userDefaults = userDefaults
        
        let hasLaunchedBefore = userDefaults.bool(forKey: hasLaunchedBeforeKey)
        if !hasLaunchedBefore {
            tokenStore.clearTokens()
            userDefaults.set(true, forKey: hasLaunchedBeforeKey)
        }
        
        if let _ = tokenStore.getAccessToken(),
           let data = userDefaults.data(forKey: userKey),
           let user = try? JSONDecoder().decode(User.self, from: data) {
            self.currentUser = user
            self.state = .loggedIn
        } else {
            tokenStore.clearTokens()
            userDefaults.removeObject(forKey: userKey)
            self.currentUser = nil
            self.state = .loggedOut
        }
    }
    
    func setLoggedIn(user: User) {
        state = .loggedIn
        updateUser(user)
    }
    
    func setLoggedOut() {
        tokenStore.clearTokens()
        clearUser()
        state = .loggedOut
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
            self.tokenStore.clearTokens()
            self.clearUser()
            self.state = .expired
            // Keeping the user data might be useful for re-login context,
            // but you can call self.clearUser() here if security demands it.
        }
    }
}
