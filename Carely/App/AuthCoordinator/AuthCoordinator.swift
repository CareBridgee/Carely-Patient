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
            PersonalInfoView(viewModel: container.makePersonalInfoViewModel(router: router)).navigationDestination(for: AuthRoute.self){
                route in
                    destination(for: route)
            }
        }
    }
    
    @ViewBuilder
    private func destination(for route: AuthRoute) -> some View {
        switch route { // inject router to each ViewModel
        case .Welcome:
            //WelcomeView(viewModel: container.makeWelcomeViewModel(router: router))
            WelcomeView()
            
        case .PhoneNumber:
                PhoneNumberView()
        
        case .OTPVerification(let phoneNumber):
            OTPVerificationView() // inject phone number into viewModel
            
        case .PersonalInfo:
            PersonalInfoView(viewModel: container.makePersonalInfoViewModel(router: router))
            
        case .ProfileSetupDecision:
            ProfileSetupDecisionView()
        }
        
    }
}

