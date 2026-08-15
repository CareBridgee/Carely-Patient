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
    @StateObject private var appState: AppState

    @MainActor
    init() {
        let container = DIContainer()

        self.diContainer = container
        _appState = StateObject(wrappedValue: container.appState)

        let token = KeychainTokenStore().getAccessToken()
        print("🔑 [Access Key]: \(token ?? "No Access Key Saved")")
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                switch appState.flow {
                case .splash:
                    SplashView(
                        viewModel: diContainer.makeSplashViewModel(),
                        onSplashFinished: {
                            appState.splashDidFinish()
                        }
                    )
                case .onboarding:
                    OnboardingView(
                        viewModel: diContainer.makeOnboardingViewModel( onNavigate: {
                            appState.completeOnboarding()
                        })
                        
                    )
                    
                case .auth:
                    AuthCoordinator(container: diContainer, appState: appState)
                    
                case .incompleteProfile:
                    AuthCoordinator(container: diContainer, appState: appState, startWithPersonalInfo: true)
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
            .background(Color.backGround.ignoresSafeArea())
            .preferredColorScheme(appState.appearance.colorScheme)
        }
    }
}
