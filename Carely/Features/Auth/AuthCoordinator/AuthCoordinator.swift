//
//  AuthCoordinator.swift
//  Carely
//
//  Created by Mohamed Ayman on 16/07/2026.
//

import Foundation
import SwiftUI

struct AuthCoordinator: View {
    let container: DIContainer
    let appState: AppState
    let startWithPersonalInfo: Bool
    
    @StateObject private var router = AuthRouter()
    
    init(container: DIContainer, appState: AppState, startWithPersonalInfo: Bool = false) {
        self.container = container
        self.appState = appState
        self.startWithPersonalInfo = startWithPersonalInfo
    }
    
    var body: some View {
        NavigationStack(path: $router.path){
            WelcomeView(
                viewModel: container.makeWelcomeViewModel(
                    router: router,
                    onAuthFinished: {
                        appState.startHomeFlow()
                    }
                )
            )
            .navigationDestination(for: AuthRoute.self){ route in
                destination(for: route)
            }
            .onAppear {
                if startWithPersonalInfo && router.path.isEmpty {
                    router.pushAsRoot(to: .PersonalInfo)
                }
            }
        }
    }
    
    @ViewBuilder
    private func destination(for route: AuthRoute) -> some View {
        switch route {
            
        case .PhoneNumber(let pendingToken):
            PhoneNumberView(
                viewModel: container.makePhoneNumberViewModel(
                    pendingToken: pendingToken,
                    router: router
                )
            )
            
        case .OTPVerification(let phoneNumber, let devOTP, let pendingToken):
                    OTPVerificationView(
                        viewModel: container.makeOTPVerificationViewModel(
                            phoneNumber: phoneNumber,
                            devOTP: devOTP,
                            pendingToken: pendingToken,
                            router: router,
                            onAuthFinished: {
                                appState.startHomeFlow()
                            },
                            onGoToDecision: {
                                appState.goToProfileSetupDecision()
                            }
                        )
                    )
        case .PersonalInfo:
            PersonalInfoView(
                viewModel: container.makePersonalInfoViewModel(
                    router: router,
                    onPersonalDataSaved: {
                        appState.goToProfileSetupDecision()
                    }
                )
            )
        }
    }
}
