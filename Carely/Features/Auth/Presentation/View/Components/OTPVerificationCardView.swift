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
        VStack(spacing: Spacing.s24) {
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
        .padding(Spacing.s24)
        .background(
            RoundedRectangle.carely(Radius.r20)
                .fill(Color.surface)
                .shadow(color: Color.black.opacity(0.08), radius: 15, x: 0, y: 10)
        )
        .padding(.horizontal, Spacing.s16)
        .animation(CarelyMotion.springDefault, value: viewModel.errorMessage)
        .animation(CarelyMotion.springDefault, value: viewModel.successMessage)
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
            .frame(height: 56)
            .background(
                Capsule()
                    .fill(viewModel.isVerifyEnabled ? Color.brandPrimary : Color.disable)
            )
        }
        .disabled(!viewModel.isVerifyEnabled)
        .animation(.easeInOut(duration: CarelyMotion.durationFast), value: viewModel.isVerifyEnabled)
    }
}
