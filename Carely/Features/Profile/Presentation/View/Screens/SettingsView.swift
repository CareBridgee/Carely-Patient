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
