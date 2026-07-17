//
//  AppState.swift
//  Carely
//
//  Created by Mohamed Ayman on 16/07/2026.
//

import SwiftUI

enum Phase {
    case auth
    case home
}

final class AppState: ObservableObject {

    @Published private(set) var isSignedIn: Bool {
        didSet {
            UserDefaults.standard.set(isSignedIn, forKey: Self.signedInKey)
        }
    }

    var phase: Phase {
        isSignedIn ? .home : .auth
    }

    private static let signedInKey = "isSignedIn"

    init() {
        self.isSignedIn = UserDefaults.standard.bool(forKey: Self.signedInKey)
    }

    func signIn() {
        isSignedIn = true
        print("logged in")
    }

    func signOut() {
        isSignedIn = false
        print("logged out")
    }
}
