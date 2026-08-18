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
    
    // 1. Add the ScenePhase environment variable to track app state
    @Environment(\.scenePhase) var scenePhase
    
    // 2. Declare the recovery service
    let refundRecoveryService: RefundRecoveryService

    @MainActor
    init() {
        let container = DIContainer()

        self.diContainer = container
        _appState = StateObject(wrappedValue: container.appState)

        // Initialize the recovery service
        // (Note: Adjust 'container.networkClient' to however you usually access your network client in the DI container)
        self.refundRecoveryService = RefundRecoveryService(
                 walletService: WalletServiceImpl(networkClient: container.networkClient),
                 historyService: HistoryServiceImpl(networkClient: container.networkClient) 
             )

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
                    NavigationStack {
                        ProfileSetupCoordinatorView(
                            coordinator: diContainer.makeProfileSetupCoordinator(),
                            container: diContainer,
                            mode: .onboarding,
                            onFinish: { appState.startHomeFlow() },
                            onBack: { appState.goToProfileSetupDecision() }
                        )
                    }
                    
                case .home:
                    MainTabCoordinatorView(container: diContainer, appState: appState)
                }
            }
            .background(Color.backGround.ignoresSafeArea())
            .preferredColorScheme(appState.appearance.colorScheme)
            // 3. Attach the lifecycle listener to the main Group
            .onChange(of: scenePhase) {
                // This triggers the exact millisecond the app comes to the foreground
                if scenePhase == .active {
                    Task {
                        await refundRecoveryService.processPendingRefunds()
                    }
                }
            }
        }
    }
}
