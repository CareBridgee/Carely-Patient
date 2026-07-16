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

    // MARK: Body

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: Layout.sectionSpacing) {
                appLogoSection
                    .padding(.top, Layout.appLogoTopPadding)

                titleAndSubtitleSection

                actionButtonsSection

                encryptionNoticeBanner

                securityIndicatorsRow
                    .padding(.top, Layout.securityIndicatorsTopPadding)
            }
            .padding(.horizontal, Layout.horizontalPadding)
            .padding(.bottom, Layout.bottomPadding)
        }
        .background(Color.backGround.ignoresSafeArea())
    }
}

// MARK: - Sections

private extension ProfileSetupDecisionView {

    var appLogoSection: some View {
        ZStack {
            Circle()
                .fill(Color.primary.opacity(Layout.outerCircleOpacity))
                .frame(width: Layout.outerCircleSize, height: Layout.outerCircleSize)

            Circle()
                .fill(Color.primary.opacity(Layout.innerCircleOpacity))
                .frame(width: Layout.innerCircleSize, height: Layout.innerCircleSize)

            Image("app-logo")
                .resizable()
                .scaledToFit()
                .frame(width: Layout.appLogoSize, height: Layout.appLogoSize)
                .offset(y: Layout.appLogoOffsetY)
        }
    }

    var titleAndSubtitleSection: some View {
        VStack(spacing: Layout.titleSubtitleSpacing) {
            Text("Help us personalize your care")
                .carelyText(style: .heading3, weight: .bold)
                .foregroundStyle(Color.primaryFont)
                .multilineTextAlignment(.center)

            Text("Complete your health profile to receive more accurate AI assessments and better nurse recommendations.")
                .carelyText(style: .bodySmall, weight: .regular)
                .foregroundStyle(Color.secondaryFont)
                .multilineTextAlignment(.center)
                .lineSpacing(Layout.subtitleLineSpacing)
                .padding(.horizontal, Layout.subtitleHorizontalPadding)
        }
    }

    var actionButtonsSection: some View {
        VStack(spacing: Layout.buttonSpacing) {
            CompleteHealthProfileButton(action: viewModel.completeHealthProfileTapped)
            SkipForNowButton(action: viewModel.skipForNowTapped)
        }
    }

    var encryptionNoticeBanner: some View {
        EncryptionNoticeBanner(
            message: "Completing your profile helps us provide more accurate AI insights and better nurse recommendations. Your information is encrypted and securely protected."
        )
        .padding(.top, Layout.encryptionNoticeTopPadding)
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

// MARK: - Components

private struct CompleteHealthProfileButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: ProfileSetupDecisionView.Layout.buttonTextSpacing) {
                    Text("Complete Health Profile")
                        .carelyText(style: .button, weight: .bold)
                    Text("(RECOMMENDED)")
                        .carelyText(style: .caption, weight: .semiBold)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: ProfileSetupDecisionView.Layout.buttonIconSize, weight: .bold))
            }
            .foregroundStyle(Color.onPrimary)
            .padding(.horizontal, ProfileSetupDecisionView.Layout.buttonHorizontalPadding)
            .padding(.vertical, ProfileSetupDecisionView.Layout.buttonVerticalPadding)
            .background(
                RoundedRectangle(cornerRadius: ProfileSetupDecisionView.Layout.buttonCornerRadius)
                    .fill(Color.primary)
            )
        }
    }
}

private struct SkipForNowButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: ProfileSetupDecisionView.Layout.buttonTextSpacing) {
                    Text("Skip for Now")
                        .carelyText(style: .button, weight: .bold)
                        .foregroundStyle(Color.primary)
                    Text("Set up your profile later")
                        .carelyText(style: .bodySmall, weight: .regular)
                        .foregroundStyle(Color.secondaryFont)
                }
                Spacer()
                Image(systemName: "arrow.right")
                    .font(.system(size: ProfileSetupDecisionView.Layout.buttonIconSize, weight: .bold))
                    .foregroundStyle(Color.primary)
            }
            .padding(.horizontal, ProfileSetupDecisionView.Layout.buttonHorizontalPadding)
            .padding(.vertical, ProfileSetupDecisionView.Layout.buttonVerticalPadding)
            .background(
                RoundedRectangle(cornerRadius: ProfileSetupDecisionView.Layout.buttonCornerRadius)
                    .fill(Color.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: ProfileSetupDecisionView.Layout.buttonCornerRadius)
                            .stroke(Color.divider, lineWidth: ProfileSetupDecisionView.Layout.buttonBorderWidth)
                    )
            )
        }
    }
}

private struct EncryptionNoticeBanner: View {
    let message: String

    var body: some View {
        HStack(alignment: .top, spacing: ProfileSetupDecisionView.Layout.encryptionNoticeIconSpacing) {
            Image(systemName: "lock.shield.fill")
                .foregroundStyle(Color.primary.opacity(ProfileSetupDecisionView.Layout.encryptionNoticeIconOpacity))
                .font(.system(size: ProfileSetupDecisionView.Layout.encryptionNoticeIconSize))
                .padding(.top, ProfileSetupDecisionView.Layout.encryptionNoticeIconTopPadding)

            Text(message)
                .carelyText(style: .caption, weight: .regular)
                .foregroundStyle(Color.secondaryFont)
                .lineSpacing(ProfileSetupDecisionView.Layout.encryptionNoticeLineSpacing)

            Spacer()
        }
        .padding(ProfileSetupDecisionView.Layout.encryptionNoticePadding)
        .background(
            RoundedRectangle(cornerRadius: ProfileSetupDecisionView.Layout.encryptionNoticeCornerRadius)
                .fill(Color.surfaceVariant.opacity(ProfileSetupDecisionView.Layout.encryptionNoticeBackgroundOpacity))
        )
    }
}

private struct SecurityIndicator: View {
    let icon: String
    let title: String

    var body: some View {
        HStack(spacing: ProfileSetupDecisionView.Layout.securityIndicatorSpacing) {
            Image(systemName: icon)
                .font(.system(size: ProfileSetupDecisionView.Layout.securityIndicatorIconSize, weight: .semibold))
                .foregroundStyle(Color.secondaryFont)
            Text(title)
                .carelyText(style: .caption, weight: .semiBold)
                .foregroundStyle(Color.secondaryFont)
        }
        .padding(.horizontal, ProfileSetupDecisionView.Layout.securityIndicatorHorizontalPadding)
        .padding(.vertical, ProfileSetupDecisionView.Layout.securityIndicatorVerticalPadding)
        .background(
            Capsule().fill(Color.surfaceVariant.opacity(ProfileSetupDecisionView.Layout.securityIndicatorBackgroundOpacity))
        )
    }
}

// MARK: - Layout Constants

private extension ProfileSetupDecisionView {
    enum Layout {
        // Overall scroll content
        static let sectionSpacing: CGFloat = 24
        static let horizontalPadding: CGFloat = 20
        static let bottomPadding: CGFloat = 16
        static let appLogoTopPadding: CGFloat = 56
        static let securityIndicatorsTopPadding: CGFloat = 16
        static let encryptionNoticeTopPadding: CGFloat = 4

        // App logo + surrounding circles
        static let outerCircleSize: CGFloat = 136
        static let outerCircleOpacity: CGFloat = 0.02
        static let innerCircleSize: CGFloat = 120
        static let innerCircleOpacity: CGFloat = 0.04
        static let appLogoSize: CGFloat = 80
        static let appLogoOffsetY: CGFloat = -2

        // Title + subtitle text
        static let titleSubtitleSpacing: CGFloat = 8
        static let subtitleLineSpacing: CGFloat = 3
        static let subtitleHorizontalPadding: CGFloat = 12

        // Action buttons (shared by both button styles)
        static let buttonSpacing: CGFloat = 16
        static let buttonTextSpacing: CGFloat = 4
        static let buttonIconSize: CGFloat = 18
        static let buttonHorizontalPadding: CGFloat = 24
        static let buttonVerticalPadding: CGFloat = 20
        static let buttonCornerRadius: CGFloat = 24
        static let buttonBorderWidth: CGFloat = 1

        // Encryption notice banner
        static let encryptionNoticeIconSpacing: CGFloat = 10
        static let encryptionNoticeIconSize: CGFloat = 15
        static let encryptionNoticeIconOpacity: CGFloat = 0.7
        static let encryptionNoticeIconTopPadding: CGFloat = 1
        static let encryptionNoticeLineSpacing: CGFloat = 2
        static let encryptionNoticePadding: CGFloat = 14
        static let encryptionNoticeCornerRadius: CGFloat = 14
        static let encryptionNoticeBackgroundOpacity: CGFloat = 0.6

        // Security indicators row (Secure / Private / Verified)
        static let securityIndicatorSpacing: CGFloat = 6
        static let securityIndicatorIconSize: CGFloat = 11
        static let securityIndicatorHorizontalPadding: CGFloat = 10
        static let securityIndicatorVerticalPadding: CGFloat = 6
        static let securityIndicatorBackgroundOpacity: CGFloat = 0.4
    }
}
