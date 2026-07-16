//
//  AuthCoordinator.swift
//  Carely
//
//  Created by Mohamed Ayman on 16/07/2026.
//

import Foundation
import SwiftUI

struct AuthCoordinator: View {
    @StateObject private var router = AuthRouter()
    
    let OnAuthFinished: () -> Void
    
    var body: some View {
        NavigationStack(path: $router.path){
            WelcomeView().navigationDestination(for: AuthRoute.self){
                route in
                    destination(for: route)
            }
        }
    }
    
    @ViewBuilder
    private func destination(for route: AuthRoute) -> some View {
        switch route { // inject router to each ViewModel
        case .Welcome:
            WelcomeView()
            
        case .PhoneNumber:
                PhoneNumberView()
        
        case .OTPVerification(let phoneNumber):
            OTPVerificationOTP() // inject phone number into viewModel
            
        case .PersonalInfo:
            PersonalInfoView()
            
        case .ProfileSetupDecision:
            ProfileSetupDecisionView(viewModel: ProfileSetupDecisionViewModel(router: router, onAuthFinished: OnAuthFinished))
        }
        
    }
}

