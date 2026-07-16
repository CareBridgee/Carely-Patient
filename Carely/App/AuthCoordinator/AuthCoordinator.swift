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
    @StateObject private var router = AuthRouter()
    
    let OnAuthFinished: () -> Void
    
    var body: some View {
        NavigationStack(path: $router.path){
            WelcomeView(viewModel: AuthViewModel(router: router)).navigationDestination(for: AuthRoute.self){
                route in
                    destination(for: route)
            }
        }
    }
    
    @ViewBuilder
    private func destination(for route: AuthRoute) -> some View {
        switch route { // inject router to each ViewModel
        case .Welcome:
            WelcomeView(viewModel: AuthViewModel(router: router))
            
        case .PhoneNumber:
                PhoneNumberView()
        
        case .OTPVerification(let phoneNumber):
            OTPVerificationView(
                        viewModel: container.makeOTPVerificationViewModel(
                            phoneNumber: phoneNumber,
                            router: router,
                            onAuthFinished: OnAuthFinished
                        )
                    )
            
        case .PersonalInfo:
            PersonalInfoView(viewModel: container.makePersonalInfoViewModel(router: router))
            
        case .ProfileSetupDecision:
            ProfileSetupDecisionView(viewModel: ProfileSetupDecisionViewModel(router: router, onAuthFinished: OnAuthFinished))
        }
        
    }
}

