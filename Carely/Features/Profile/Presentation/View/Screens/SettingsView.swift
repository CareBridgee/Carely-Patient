//
//  SettingsView.swift
//  Carely
//
//  Created by Mina on 25/07/2026.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel: SettingsViewModel

    init(viewModel: SettingsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            Color.backGround.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: Spacing.s20) {
                    header

                    section(title: "App Preferences") {
                        SettingsRow(
                            iconName: "globe",
                            title: "Language",
                            trailing: .value(viewModel.language),
                            action: viewModel.languageTapped
                        )
                        Divider().overlay(Color.divider)
                        SettingsRow(
                            iconName: "circle.righthalf.filled",
                            title: "Appearance",
                            trailing: .appearancePicker($viewModel.appearance)
                        )
                    }

                    section(title: "Security & Privacy") {
                        SettingsRow(
                            iconName: "lock.shield.fill",
                            title: "Privacy Policy",
                            trailing: .chevron,
                            action: viewModel.privacyPolicyTapped
                        )
                    }
                }
                .padding(Spacing.s16)
                .padding(.bottom, Spacing.s32)
            }
        }
        .careConnectNavigationBar(
            title: "Settings",
            showBackButton: true,
            onBackTapped: {
                viewModel.backTapped()
            }
        )
        .sheet(isPresented: $viewModel.showPrivacyPolicySheet) {
            privacyPolicySheet
                .presentationDetents([.fraction(0.48), .large])
                .presentationDragIndicator(.visible)
        }
        .errorToast($viewModel.errorMessage)
    }

    private var privacyPolicySheet: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: Spacing.s16) {
                Text("Privacy Policy")
                    .carelyText(style: .heading2, weight: .bold)
                    .foregroundColor(.primaryFont)
                    .padding(.top, Spacing.s16)

                VStack(alignment: .leading, spacing: Spacing.s16) {
                    Text("Your privacy and security are important to Etmaen.\n\n• Your personal and medical information is securely stored.\n• Your data is only used to provide healthcare services and improve your experience.\n• Etmaen does not share your personal information with unauthorized third parties.\n• All communication with our services is encrypted whenever possible.")
                        .carelyText(style: .bodyRegular)
                        .foregroundColor(.primaryFont)
                        .lineSpacing(6)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(Spacing.s20)
                .background(Color.surface)
                .clipShape(RoundedRectangle.carely(Radius.r24))
                .carelyShadow(.sm)
            }
            .padding(.horizontal, Spacing.s20)
            .padding(.bottom, Spacing.s24)
        }
        .background(Color.backGround.ignoresSafeArea())
    }

    private var topBar: some View {
        HStack {
//            Button(action: viewModel.backTapped) {
//                Image(systemName: "arrow.left")
//                    .carelyText(style: .bodyLarge, weight: .semiBold)
//                    .foregroundColor(.brandPrimary)
//                    .frame(width: 40, height: 40)
//                    .background(Color.surface)
//                    .clipShape(Circle())
//            }
//
            Spacer()

            Text("Settings")
                .carelyText(style: .heading3, weight: .semiBold)
                .foregroundColor(.brandPrimary)

            Spacer()

//            Color.clear.frame(width: 40, height: 40)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: Spacing.s4) {
            Text("Settings")
                .carelyText(style: .heading2, weight: .bold)
                .foregroundColor(.primaryFont)
            Text("Manage your account and app experience")
                .carelyText(style: .bodySmall)
                .foregroundColor(.secondaryFont)
        }
    }

    @ViewBuilder
    private func section<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: Spacing.s12) {
            Text(title.uppercased())
                .carelyText(style: .caption, weight: .semiBold)
                .foregroundColor(.brandPrimary)

            VStack(alignment: .leading, spacing: Spacing.s12) {
                content()
            }
            .padding(Spacing.s16)
            .background(Color.surface)
            .clipShape(RoundedRectangle.carely(Radius.r20))
            .carelyShadow(.sm)
        }
    }
}

//#Preview {
//    SettingsView(
//        viewModel: SettingsViewModel(
//            patientName: "Elena Rodriguez",
//            coordinator: ProfileCoordinator()
//        )
//    )
//}
