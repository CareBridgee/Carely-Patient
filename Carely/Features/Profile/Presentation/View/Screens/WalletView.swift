//
//  WalletView.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 16/08/2026.
//


//
//  WalletView.swift
//  Carely
//

import SwiftUI

struct WalletView: View {
    @StateObject var viewModel: WalletViewModel

    var body: some View {
        ZStack {
            Color.backGround.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: Spacing.s24) {
                    walletHeroCard
                    whyUseWalletSection
                    readyWhenYouNeedCareBanner
                }
                .padding(Spacing.s16)
            }
        }
        .careConnectNavigationBar(title: "Wallet")
        .onAppear { viewModel.onAppear() }
        .errorToast($viewModel.errorMessage)
    }

    private var walletHeroCard: some View {
        VStack(alignment: .leading, spacing: Spacing.s16) {
            VStack(alignment: .leading, spacing: Spacing.s4) {
                Text("WALLET BALANCE")
                    .carelyText(style: .caption, weight: .medium)
                    .foregroundColor(.onPrimary.opacity(0.8))

                if viewModel.isLoading && viewModel.currentUserId == nil {
                    ProgressView().tint(.onPrimary)
                } else {
                    Text(String(format: "EGP %.2f", viewModel.balance))
                        .carelyText(style: .display, weight: .bold)
                        .foregroundColor(.onPrimary)
                }
            }

            HStack(spacing: Spacing.s8) {
                Image(systemName: "checkmark.shield")
                    .foregroundColor(.onPrimary.opacity(0.9))
                Text("Your balance is secure")
                    .carelyText(style: .bodySmall)
                    .foregroundColor(.onPrimary.opacity(0.9))
            }
            .padding(.bottom, Spacing.s8)

            PrimaryButton(
                colorOfBackground: .surface,
                colorOfForground: .brandPrimary,
                title: "Add Funds",
                icon: "plus",
                iconPosition: .leading
            ) {
                viewModel.addFundsTapped()
            }
        }
        .padding(Spacing.s20)
        .background(Color.brandPrimary)
        .clipShape(RoundedRectangle.carely(Radius.r20))
        .carelyShadow(.md)
    }

    private var whyUseWalletSection: some View {
        VStack(alignment: .leading, spacing: Spacing.s16) {
            Text("Why use your wallet?")
                .carelyText(style: .heading3, weight: .bold)
                .foregroundColor(.primaryFont)

            Text("Add balance to pay for nursing visits and care services quickly and easily.")
                .carelyText(style: .bodySmall)
                .foregroundColor(.secondaryFont)

            HStack(alignment: .top, spacing: 0) {
                benefitItem(icon: "house.fill", text: "Pay for Home\nCare Services")
                Spacer()
                benefitItem(icon: "bolt.fill", text: "Faster\nBookings")
                Spacer()
                benefitItem(icon: "checkmark.shield.fill", text: "Secure &\nProtected")
            }
            .padding(.top, Spacing.s8)
        }
        .padding(Spacing.s20)
        .background(Color.surface)
        .clipShape(RoundedRectangle.carely(Radius.r20))
        .carelyShadow(.sm)
    }

    private func benefitItem(icon: String, text: String) -> some View {
        VStack(spacing: Spacing.s12) {
            Circle()
                .fill(Color.primaryContainer.opacity(0.5))
                .frame(width: 48, height: 48)
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundColor(.brandPrimary)
                )

            Text(text)
                .carelyText(style: .caption, weight: .medium)
                .foregroundColor(.primaryFont)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: 100)
    }

    private var readyWhenYouNeedCareBanner: some View {
        HStack(spacing: Spacing.s16) {
            Image(systemName: "wallet.pass.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(.brandPrimary)
                .padding(Spacing.s12)
                .background(Color.primaryContainer.opacity(0.3))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: Spacing.s4) {
                Text("Ready when you need care")
                    .carelyText(style: .bodySmall, weight: .bold)
                    .foregroundColor(.primaryFont)
                Text("Add funds to your wallet now so you can focus on what matters most.")
                    .carelyText(style: .caption)
                    .foregroundColor(.secondaryFont)
            }

            Spacer()
        }
        .padding(Spacing.s16)
        .background(Color.surface)
        .clipShape(RoundedRectangle.carely(Radius.r20))
        .carelyShadow(.sm)
    }
}
