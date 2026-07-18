//
//  ProfileSetupDecisionView.swift
//  Carely
//
//  Created by Mohamed Ayman on 16/07/2026.
//

import SwiftUI

struct ProfileSetupDecisionView: View {
    @StateObject private var viewModel: ProfileSetupDecisionViewModel

    init(viewModel: ProfileSetupDecisionViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    } 

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: Spacing.s24) {
                appLogoSection
                    .padding(.top, Spacing.s56)

                titleAndSubtitleSection

                actionButtonsSection

                encryptionNoticeBanner

                securityIndicatorsRow
                    .padding(.top, Spacing.s16)
            }
            .padding(.horizontal, Spacing.s20)
            .padding(.bottom, Spacing.s16)
        }
        .background(Color.backGround.ignoresSafeArea())
    }
}

// MARK: - Sections

private extension ProfileSetupDecisionView {

    var appLogoSection: some View {
        ZStack {
            Circle()
                .fill(Color.brandPrimary.opacity(0.02))
                .frame(width: 136, height: 136)

            Circle()
                .fill(Color.brandPrimary.opacity(0.04))
                .frame(width: 120, height: 120)

            Image("app-logo")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .offset(y: -2)
        }
    }

    var titleAndSubtitleSection: some View {
        VStack(spacing: Spacing.s8) {
            Text("Help us personalize your care")
                .carelyText(style: .heading3, weight: .bold)
                .foregroundStyle(Color.primaryFont)
                .multilineTextAlignment(.center)

            Text("Complete your health profile to receive more accurate AI assessments and better nurse recommendations.")
                .carelyText(style: .bodySmall, weight: .regular)
                .foregroundStyle(Color.secondaryFont)
                .multilineTextAlignment(.center)
                .lineSpacing(3)
                .padding(.horizontal, Spacing.s12)
        }
    }

    var actionButtonsSection: some View {
        VStack(spacing: Spacing.s16) {
            CompleteHealthProfileButton(action: viewModel.completeHealthProfileTapped)
            SkipForNowButton(action: viewModel.skipForNowTapped)
        }
    }

    var encryptionNoticeBanner: some View {
        EncryptionNoticeBanner(
            message: "Completing your profile helps us provide more accurate AI insights and better nurse recommendations. Your information is encrypted and securely protected."
        )
        .padding(.top, Spacing.s4)
    }

    var securityIndicatorsRow: some View {
        HStack {
            Spacer()
            SecurityIndicator(icon: "lock.fill", title: "Secure")
            Spacer()
            SecurityIndicator(icon: "eye.slash.fill", title: "Private")
            Spacer()
            SecurityIndicator(icon: "checkmark.seal.fill", title: "Verified")
            Spacer()
        }
    }
}
