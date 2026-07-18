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
            Image.careConnect
                .resizable()
                .scaledToFit()
                .frame(width: 350, height: 350)
            Spacer()
            Text("Care Connect")
                .carelyText(style: .display, weight: .light)
                .foregroundColor(.brandPrimary)
                
            
            Text("Reassuring care for you and your loved ones")
                .carelyText(style: .bodyRegular, weight: .light)
            
            Spacer()
            
            loginButton(title: "Continue with Google", image: .googleIcon, backgroundColor: .surface, foregroundColor: .onSurface, horizontalPadding: 24){
                showAlert = true
            }.alert("Continue with Google", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Will be available in future")
            }
            
            loginButton(title: "Continue with Phone", image: Image(systemName: "phone"), backgroundColor: .onSurface, foregroundColor: .surface, horizontalPadding: 24){
                viewModel.continueWithPhone()
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backGround)
    }
}

#Preview {
    WelcomeView(viewModel: WelcomeViewModel(router: AuthRouter()))
}
