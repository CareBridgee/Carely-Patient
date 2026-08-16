//
//  ErrorStateView.swift
//  Carely
//
//  Created by Mina on 16/08/2026.
//
//  Reusable full-screen error state for failed fetches, with a Retry action.
//  Always displays the exact message passed in (typically the server's own
//  string, surfaced via `NetworkError.server(_, message:)`) instead of a
//  hardcoded "Something went wrong" string.
//

import SwiftUI

struct ErrorStateView: View {
    /// The exact message to show. Callers should pass
    /// `(error as? NetworkError)?.errorDescription ?? error.localizedDescription`
    /// (or `error.carelyDescription`) rather than a static fallback string.
    let message: String
    var title: String = "Couldn't load this"
    var retryTitle: String = "Retry"
    var onRetry: () -> Void

    var body: some View {
        VStack(spacing: Spacing.s24) {
            ZStack {
                Circle()
                    .fill(Color.errorContainer.opacity(0.5))
                    .frame(width: 96, height: 96)

                Image(systemName: "wifi.exclamationmark")
                    .carelyText(style: .heading1)
                    .foregroundColor(.error)
            }

            VStack(spacing: Spacing.s8) {
                Text(title)
                    .carelyText(style: .heading3, weight: .bold)
                    .foregroundColor(.primaryFont)

                Text(message)
                    .carelyText(style: .bodyRegular)
                    .foregroundColor(.secondaryFont)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }

            PrimaryButton(
                title: retryTitle,
                radius: Radius.pill,
                icon: "arrow.clockwise",
                action: onRetry
            )
        }
        .padding(.horizontal, Spacing.s24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Convenience for mapping any thrown error into the view's message

extension ErrorStateView {
    /// Builds the view straight from a caught `Error`, extracting the exact
    /// server string when available.
    init(error: Error, title: String = "Couldn't load this", retryTitle: String = "Retry", onRetry: @escaping () -> Void) {
        self.init(
            message: error.carelyDescription,
            title: title,
            retryTitle: retryTitle,
            onRetry: onRetry
        )
    }
}

// MARK: - Preview

//#Preview {
//    ErrorStateView(
//        message: "No nurses available in your area right now.",
//        onRetry: {}
//    )
//}
