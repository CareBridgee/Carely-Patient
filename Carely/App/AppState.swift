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
    case splash
    case onboarding
    case auth
    case incompleteProfile
    case profileSetupDecision
    case profileSetup
    case home
}

@MainActor
final class AppState: ObservableObject {
    @Published private(set) var flow: AppFlow = .splash
    @Published private(set) var appearance: AppAppearance
    
    private var cancellables = Set<AnyCancellable>()
    private let sessionManager: SessionManager
    private var appSettings: AppSettingsProtocol
    init(sessionManager: SessionManager, appSettings: AppSettingsProtocol = AppSettings.shared) {
        self.sessionManager = sessionManager
        self.appSettings = appSettings
        self.appearance = appSettings.appearance
        self.flow = .splash // We always start at splash. splashDidFinish decides the next flow.
        // setupSessionObserver()
    }

    func setAppearance(_ newAppearance: AppAppearance) {
        appSettings.appearance = newAppearance
        appearance = newAppearance
    }
    private func setupSessionObserver() {
        sessionManager.$state
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .loggedOut, .expired:
                    self.flow = .auth
                case .loggedIn:
                    if let user = self.sessionManager.currentUser, user.isProfileIncomplete {
                        self.flow = .incompleteProfile
                    } else {
                        self.flow = .home
                    }
                case .restoring:
                    self.flow = .splash
                }
            }
            .store(in: &cancellables)
    }
    func splashDidFinish() {
        if !appSettings.hasSeenOnboarding {
            flow = .onboarding
        } else if sessionManager.state == .loggedIn {
            if let user = sessionManager.currentUser, user.isProfileIncomplete {
                flow = .incompleteProfile
            } else {
                flow = .home
            }
        } else if sessionManager.state == .restoring {
            flow = .splash
        } else {
            flow = .auth
        }
    }
    
    func completeOnboarding() {
        appSettings.hasSeenOnboarding = true
        flow = .auth
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
