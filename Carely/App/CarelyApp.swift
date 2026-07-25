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
                AuthCoordinator(container: diContainer, appState: appState)


            case .profileSetupDecision:
                ProfileSetupDecisionView(
                    viewModel: diContainer.makeProfileSetupDecisionViewModel(
                        oncompleteHealthProfileClicked: { appState.startProfileSetup() },
                        onSkipButtonClicked: { appState.startHomeFlow() }
                    )
                )
            case .profileSetup:
                ProfileSetupCoordinatorView(
                    coordinator: diContainer.makeProfileSetupCoordinator(),
                    container: diContainer,
                    onFinish: { appState.startHomeFlow() }
                )

            case .home:
                MainTabCoordinatorView(container: diContainer, appState: appState)

            }
        }
    }
}
