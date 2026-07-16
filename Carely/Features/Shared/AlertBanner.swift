//
//  AlertBanner.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 16/07/2026.
//


import Foundation
import SwiftUI

enum AlertBannerStyle {
    case success
    case error

    var backgroundColor: Color {
        switch self {
        case .success: return .successContainer
        case .error: return .errorContainer
        }
    }

    var foregroundColor: Color {
        switch self {
        case .success: return .onSuccessContainer
        case .error: return .onErrorContainer
        }
    }

    var iconName: String {
        switch self {
        case .success: return "checkmark.circle.fill"
        case .error: return "exclamationmark.circle.fill"
        }
    }
}

struct AlertBanner: View {
    let style: AlertBannerStyle
    let message: String

    var body: some View {
        HStack(alignment: .top, spacing: Spacing.xs) {
            Image(systemName: style.iconName)
                .foregroundStyle(style.foregroundColor)

            Text(message)
                .carelyText(style: .bodySmall, weight: .medium)
                .foregroundStyle(style.foregroundColor)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.leading)

            Spacer(minLength: 0)
        }
        .padding(Spacing.sm)
        .background(
            RoundedRectangle.trueFit(Radius.md)
                .fill(style.backgroundColor)
        )
        .transition(.move(edge: .top).combined(with: .opacity))
    }
}
