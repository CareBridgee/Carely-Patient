//
//  AuthView.swift
//  Carely
//
//  Created by Mina on 15/07/2026.
//

import Foundation
import SwiftUI

struct WelcomeView : View {
    @StateObject private var viewModel: WelcomeViewModel
    @State private var showAlert = false
    
    init(viewModel: WelcomeViewModel) {
            _viewModel = StateObject(wrappedValue: viewModel)
        }

    
    var body: some View {
        VStack {
            Spacer(minLength: Spacing.s64)
            Spacer(minLength: Spacing.s20)

            Image.careConnect
                .resizable()
                .scaledToFit()
                .frame(width: 350, height: 350)
              Spacer()
//            Text("Care Connect")
//                .carelyText(style: .display, weight: .light)
//                .foregroundColor(.brandPrimary)
                
            
            Text("Your trusted partner for professional home healthcare, bringing reassuring care to you and your loved ones.")
                .carelyText(style: .bodyRegular, weight: .light)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.s24)
            
            Spacer()
            
            loginButton(title: "Continue with Google",
                image: .googleIcon,
                backgroundColor: .surface,
                foregroundColor: .onSurface,
                horizontalPadding: 24,
                strokeColor: Color.secondary
            ) {
                showAlert = true
            }.alert("Continue with Google", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Will be available in future")
            }
            
            loginButton(title: "Continue with Phone",
            image: Image(systemName: "phone"),
            backgroundColor: .mintSurface,
            foregroundColor: .primary,
            horizontalPadding: 24,
            strokeColor: Color.primaryVariant
            ){
                viewModel.continueWithPhone()
            }
            Spacer()
            termsAndPrivacyText
                .padding(.horizontal, 32)
                .padding(.bottom, 16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backGround)
    }
    private var termsAndPrivacyText: some View {
            (
                Text("Joining our app means you agree with our ")
                    .foregroundColor(.secondaryFont)
                +
                Text("Terms of use ")
                    .foregroundColor(.brandPrimary)
                    .fontWeight(.medium)
                +
                Text("and ")
                    .foregroundColor(.primaryFont)
                    .fontWeight(.medium)
                +
                Text("privacy policy")
                    .foregroundColor(.brandPrimary)
                    .fontWeight(.medium)
            )
            .carelyText(style: .bodySmall, weight: .regular)
            .multilineTextAlignment(.center)
        }
}

#Preview {
    WelcomeView(viewModel: WelcomeViewModel(router: AuthRouter()))
}
