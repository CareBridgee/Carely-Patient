//
//  PersonalInfoView.swift
//  Carely
//
//  Created by Mohamed Ayman on 16/07/2026.
//
import SwiftUI

struct PersonalInfoView: View {
    @StateObject var viewModel: PersonalInfoViewModel
    @Environment(\.dismiss) var dismiss
    
    init(viewModel: @autoclosure @escaping () -> PersonalInfoViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel())
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: Spacing.s20) {
                PersonalInfoFormCard(viewModel: viewModel)
                    .padding(.top, Spacing.s24)
                Spacer()
            }
            .padding(.horizontal, Spacing.s16)
            .background(Color.backGround.ignoresSafeArea())
            .careConnectNavigationBar(title: "Enaya", showBackButton: false)
            .blur(radius: viewModel.isLoading ? 3 : 0)
            
            if viewModel.isLoading {
                ZStack {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 16) {
                        ProgressView()
                            .scaleEffect(1.5)
                            .tint(.brandPrimary)
                        
                        Text("Please wait...")
                            .carelyText(style: .bodyRegular, weight: .bold)
                            .foregroundColor(.primaryFont)
                    }
                    .padding(32)
                    .background(Color.surface)
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
                }
                .zIndex(1)
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }
        }
        .animation(.easeInOut(duration: 0.3), value: viewModel.isLoading)
    }
}
