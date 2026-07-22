//
//  CarelyApp.swift
//  Carely
//
//  Created by Mona Zarea on 15/07/2026.
//

import SwiftUI

@main
struct CarelyApp: App {
    
    let diContainer: DIContainer
    @StateObject private var appState = AppState()
    
    @MainActor
    init() {
        self.diContainer = DIContainer()
    }
    
    var body: some Scene {
        WindowGroup {
            switch appState.flow {

            case .auth:
                ProfileSetupCoordinatorView(
                    coordinator: diContainer.makeProfileSetupCoordinator(),
                    container: diContainer,
                    onFinish: { appState.startHomeFlow() }
                )

            case .profileSetupDecision:
                ProfileSetupCoordinatorView(
                    coordinator: diContainer.makeProfileSetupCoordinator(),
                    container: diContainer,
                    onFinish: { appState.startHomeFlow() }
                )

            case .profileSetup:
                ProfileSetupCoordinatorView(
                    coordinator: diContainer.makeProfileSetupCoordinator(),
                    container: diContainer,
                    onFinish: { appState.startHomeFlow() }
                )

            case .home:
                ProfileSetupCoordinatorView(
                    coordinator: diContainer.makeProfileSetupCoordinator(),
                    container: diContainer,
                    onFinish: { appState.startHomeFlow() }
                )
            }
        }
    }
}
