//
//  PaymobBottomSheetView.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 16/08/2026.
//


import SwiftUI

struct PaymobBottomSheetView: View {
    let checkoutURL: URL
    let onResult: (Bool) -> Void

    private enum PaymentOutcome {
        case success
        case failure
    }

    @State private var outcome: PaymentOutcome? = nil

    var body: some View {
        VStack(spacing: 0) {
            header

            ZStack {
                PaymobWebView(url: checkoutURL) { success in
                    withAnimation { outcome = success ? .success : .failure }
                }
                .opacity(outcome == nil ? 1 : 0)

                if let outcome {
                    resultView(for: outcome)
                        .transition(.opacity.combined(with: .scale(scale: 0.92)))
                }
            }
        }
        .background(Color.surface)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private var header: some View {
        HStack(spacing: Spacing.s12) {
            logoView

            VStack(alignment: .leading, spacing: 2) {
                Text(PaymobConfig.appName)
                    .font(.headline)
                    .foregroundColor(.onPrimary)
                Text("Secure Payment")
                    .font(.caption)
                    .foregroundColor(.onPrimary.opacity(0.85))
            }

            Spacer()

            Image(systemName: "lock.fill")
                .foregroundColor(.onPrimary.opacity(0.85))
        }
        .padding(Spacing.s16)
        .background(Color.brandPrimary)
    }

    /// Falls back to an initial-letter badge if "AppLogo" isn't in the
    /// asset catalog, so the header never renders visibly empty.
    private var logoView: some View {
        Group {
            if let logo = PaymobConfig.appIcon {
                Image(uiImage: logo)
                    .resizable()
                    .scaledToFit()
            } else {
                Text(String(PaymobConfig.appName.prefix(1)))
                    .font(.headline.bold())
                    .foregroundColor(.brandPrimary)
            }
        }
        .frame(width: 32, height: 32)
        .background(Color.onPrimary)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }

    private func resultView(for outcome: PaymentOutcome) -> some View {
        VStack(spacing: Spacing.s16) {
            Image(systemName: outcome == .success ? "checkmark.circle.fill" : "xmark.circle.fill")
                .font(.system(size: 56))
                .foregroundColor(outcome == .success ? .green : .red)

            Text(outcome == .success ? "Payment Successful" : "Payment Failed")
                .font(.headline)
                .foregroundColor(.primaryFont)

            Text(outcome == .success
                 ? "Adding the amount to your wallet now…"
                 : "Your card wasn't charged. You can close this and try again.")
                .font(.subheadline)
                .foregroundColor(.secondaryFont)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.s24)

            if outcome == .success {
                ProgressView().padding(.top, Spacing.s8)
            } else {
                Button("Close") { onResult(false) }
                    .padding(.top, Spacing.s8)
            }
        }
        .padding(Spacing.s24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.surface)
        .onAppear {
            // Success is shown briefly, then hands off to
            // TopUpViewModel.handlePaymobSuccess(), which fires the real
            // PATCH /credit call — this delay is just so you actually see
            // confirmation before the sheet closes, not a fake wait.
            if outcome == .success {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    onResult(true)
                }
            }
        }
    }
}
