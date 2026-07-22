//
//  AppState.swift
//  Carely
//
//  Created by Mohamed Ayman on 16/07/2026.
//

import SwiftUI
import Foundation

enum AppFlow: Equatable {
    case auth
    case profileSetupDecision
    case profileSetup
    case home
}

final class AppState: ObservableObject {

    @Published private(set) var flow: AppFlow

    private static let signedInKey = "isSignedIn"

    init() {
        let isSignedIn = UserDefaults.standard.bool(forKey: Self.signedInKey)
        self.flow = isSignedIn ? .home : .auth
    }

    func signIn() {
        UserDefaults.standard.set(true, forKey: Self.signedInKey)
    }
    
    func signOut() {
        UserDefaults.standard.set(false, forKey: Self.signedInKey)
    }
    
    func startProfileSetup() {
        flow = .profileSetup //ProfileSetupCoordinator
    }

    func startHomeFlow() {
        flow = .home //HomeCoordinator
    }

    func goToProfileSetupDecision() {
        flow = .profileSetupDecision // oneScreen
    }
    
    func startAuthFlow() {
        flow = .auth // AuthCoordinator
    }
    
}
