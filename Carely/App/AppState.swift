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
    case profileSetupDecision
    case profileSetup
    case home
}

@MainActor
final class AppState: ObservableObject {
    @Published private(set) var flow: AppFlow = .splash
    
    private let sessionManager: SessionManager
    private var appSettings: AppSettingsProtocol
    init(sessionManager: SessionManager, appSettings: AppSettingsProtocol = AppSettings.shared) {
        self.sessionManager = sessionManager
        self.appSettings = appSettings
      //  self.flow = sessionManager.state == .loggedIn ? .home : .auth
    }
    
    func splashDidFinish() {
        if !appSettings.hasSeenOnboarding {
            flow = .onboarding
        } else if sessionManager.state == .loggedIn {
            flow = .home
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
