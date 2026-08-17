//
//  TopUpWalletView.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 16/08/2026.
//

//
//  TopUpWalletView.swift
//  Carely
//

import SwiftUI

struct TopUpWalletView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: TopUpViewModel

    var body: some View {
        ZStack {
            Color.backGround.ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: Spacing.s24) {

                        VStack(alignment: .leading, spacing: Spacing.s8) {
                            Text("Enter Amount")
                                .carelyText(style: .bodySmall, weight: .medium)
                                .foregroundColor(.secondaryFont)

                            CarelyTextField(
                                placeholder: "0.00",
                                text: $viewModel.amountString,
                                size: .large,
                                leadingIcon: nil,
                                trailingText: "EGP",
                                keyboardType: .decimalPad
                            )

                            HStack(spacing: Spacing.s4) {
                                Image(systemName: "info.circle")
                                    .font(.system(size: 12))
                                Text("Enter an amount to add to your balance")
                                    .carelyText(style: .caption)
                            }
                            .foregroundColor(.hint)
                            .padding(.top, Spacing.s4)
                        }

                        VStack(alignment: .leading, spacing: Spacing.s12) {
                            Text("Payment Method")
                                .carelyText(style: .bodySmall, weight: .medium)
                                .foregroundColor(.secondaryFont)

                            PaymentSeletionMethodRow(
                                title: "Credit / Debit Card",
                                subtitle: "Pay securely using your card",
                                icon: "creditcard.fill",
                                isSelected: true,
                                isEnabled: true
                            )

                            PaymentSeletionMethodRow(
                                title: "Apple Pay",
                                subtitle: "Coming soon",
                                icon: "apple.logo",
                                isSelected: false,
                                isEnabled: false
                            )

                            PaymentSeletionMethodRow(
                                title: "Mobile Wallet",
                                subtitle: "Vodafone Cash, Orange Money, Etisalat Cash",
                                icon: "iphone.gen3",
                                isSelected: false,
                                isEnabled: false
                            )

                            PaymentSeletionMethodRow(
                                title: "valU",
                                subtitle: "Coming soon",
                                icon: "creditcard.and.123",
                                isSelected: false,
                                isEnabled: false
                            )

                            PaymentSeletionMethodRow(
                                title: "Meeza",
                                subtitle: "Coming soon",
                                icon: "creditcard.circle",
                                isSelected: false,
                                isEnabled: false
                            )
                        }

                        HStack(spacing: Spacing.s12) {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.brandPrimary)
                            Text("Your payment information is safe and secure. We do not store your card details.")
                                .carelyText(style: .caption)
                                .foregroundColor(.secondaryFont)
                            Spacer()
                        }
                        .padding(Spacing.s16)
                        .background(Color.surfaceVariant)
                        .clipShape(RoundedRectangle.carely(Radius.r12))
                    }
                    .padding(Spacing.s16)
                }

                VStack {
                    PrimaryButton(
                        title: "Continue",
                        isLoading: viewModel.isLoading,
                        isEnabled: viewModel.isContinueEnabled
                    ) {
                        viewModel.startTopUpFlow()
                    }
                }
                .padding(Spacing.s16)
                .background(Color.surface.ignoresSafeArea(.all, edges: .bottom))
                .carelyShadow(.lg)
            }
        }
        .careConnectNavigationBar(title: "Add Funds")
        .sheet(isPresented: $viewModel.showPaymobSheet, onDismiss: {
            viewModel.sheetDismissedByUser()
        }) {
            if let url = viewModel.checkoutURL {
                PaymobBottomSheetView(checkoutURL: url) { success in
                    if success {
                        viewModel.handlePaymobSuccess()
                    } else {
                        viewModel.handlePaymobRejected(message: "Payment failed")
                    }
                }
                .presentationDetents([.large, .medium])
                .presentationDragIndicator(.visible)
            }
        }
        .errorToast($viewModel.errorMessage)
    }
}
