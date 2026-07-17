//
//  OTPVerificationCardView.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 16/07/2026.
//


import SwiftUI

struct OTPVerificationCardView: View {
    @ObservedObject var viewModel: OTPVerificationViewModel
    
    var body: some View {
        VStack(spacing: Spacing.xl) {
            if let errorMessage = viewModel.errorMessage {
                AlertBanner(style: .error, message: errorMessage)
            }
            if let successMessage = viewModel.successMessage {
                        AlertBanner(style: .success, message: successMessage)
                    }
            OTPDigitInputField(
                code: $viewModel.otpCode,
                length: viewModel.otpLength,
                isError: viewModel.errorMessage != nil
            )

            verifyButton
        }
        .padding(Spacing.lg)
        .background(
            RoundedRectangle.trueFit(Radius.lg)
                .fill(Color.surface)
        )
        .animation(TrueFitMotion.springDefault, value: viewModel.errorMessage)
        .animation(TrueFitMotion.springDefault, value: viewModel.successMessage)
    }
    
    private var verifyButton: some View {
        Button {
            Task { await viewModel.verifyOTP() }
        } label: {
            ZStack {
                if viewModel.isLoading {
                    ProgressView()
                        .tint(Color.onPrimary)
                } else {
                    Text("VERIFY")
                        .carelyText(style: .button, weight: .semiBold)
                        .foregroundStyle(viewModel.isVerifyEnabled ? Color.onPrimary : Color.onDisable)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(
                Capsule()
                    .fill(viewModel.isVerifyEnabled ? Color.primary : Color.disable)
            )
        }
        .disabled(!viewModel.isVerifyEnabled)
        .animation(.easeInOut(duration: TrueFitMotion.durationFast), value: viewModel.isVerifyEnabled)
    }
}
