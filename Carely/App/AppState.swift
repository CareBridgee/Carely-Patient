//
//  AppState.swift
//  Carely
//
//  Created by Mohamed Ayman on 16/07/2026.
//

import SwiftUI
import Combine
import Foundation

enum AppFlow: Equatable {
    case auth
    case profileSetupDecision
    case profileSetup
    case home
}

@MainActor
final class AppState: ObservableObject {
    @Published private(set) var flow: AppFlow

    private let sessionManager: SessionManager
    private var cancellables = Set<AnyCancellable>()

    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
        self.flow =  .auth
        //sessionManager.state == .loggedIn ? .home :
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
