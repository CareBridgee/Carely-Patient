//
//  OTPVerificationView.swift
//  Carely
//
//  Created by Mohamed Ayman on 16/07/2026.
//

import SwiftUI

struct OTPVerificationView: View {
    @StateObject private var viewModel: OTPVerificationViewModel

    init(viewModel: OTPVerificationViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 0) {
            AuthHeaderView(title: "CareConnect") {
                viewModel.goBack()
            }
            
            ScrollView {
                VStack(spacing: Spacing.xl) {
                    OTPHeaderIconView()

                    VStack(spacing: Spacing.xs) {
                        Text("Verify Phone")
                            .carelyText(style: .heading2, weight: .bold)
                            .foregroundStyle(Color.primaryFont)

                        Text("We've sent a 4-digit code to your phone number")
                            .carelyText(style: .bodyRegular, weight: .regular)
                            .foregroundStyle(Color.secondaryFont)
                            .multilineTextAlignment(.center)

                        Text(viewModel.phoneNumber)
                            .carelyText(style: .bodyRegular, weight: .semiBold)
                            .foregroundStyle(Color.secondaryFont)
                    }
                    .padding(.horizontal, Spacing.xl)

                    OTPVerificationCardView(viewModel: viewModel)

                    OTPResendSectionView {
                        // TODO: Call viewModel.resendOTP() when backend is ready
                        print("Resend code triggered")
                    }
                }
                .padding(.top, Spacing.xxl)
                .padding(.horizontal, Spacing.md)
                .padding(.bottom, Spacing.xxl)
            }
        }
        .background(Color.backGround.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    OTPVerificationView(
        viewModel: OTPVerificationViewModel(
            phoneNumber: "+20 100 123 4567",
            verifyOTPUseCase: VerifyOTPUseCase(repository: AuthRepositoryImpl()),
            router: AuthRouter()
        )
    )
}
