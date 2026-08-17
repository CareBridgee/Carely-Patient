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
            Color.backGround.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: Spacing.s20) {
                    PersonalInfoFormCard(viewModel: viewModel)
                        .padding(.top, Spacing.s16)
                }
                .padding(.horizontal, Spacing.s16)
                .padding(.bottom, Spacing.s32)
            }
            .careConnectNavigationBar(
                title: "Etmaen",
                showBackButton: true,
                onBackTapped: {
                    viewModel.logoutTapped()
                }
            )
        }
        .etmaenLoadingOverlay(isPresented: viewModel.isLoading, message: "Please wait...")
        .alert("Log Out?", isPresented: $viewModel.showLogoutConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Log Out", role: .destructive) {
                viewModel.confirmLogout()
            }
        } message: {
            Text("Are you sure you want to log out and exit the setup?")
        }
        .errorToast($viewModel.apiErrorMessage)
    }
}
