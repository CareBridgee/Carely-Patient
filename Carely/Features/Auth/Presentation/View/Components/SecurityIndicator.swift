//
//  SecurityIndicator.swift
//  Carely
//
//  Created by Mohamed Ayman on 17/07/2026.
//

import SwiftUI

struct SecurityIndicator: View {
    let icon: String
    let title: String

    var body: some View {
        HStack(spacing: Spacing.s8) {
            Image(systemName: icon)
                .font(.system(size: IconSize.s12, weight: .semibold))
                .foregroundStyle(Color.secondaryFont)

            Text(title)
                .carelyText(style: .caption, weight: .semiBold)
                .foregroundStyle(Color.secondaryFont)
        }
        .padding(.horizontal, Spacing.s12)
        .padding(.vertical, Spacing.s8)
        .background(
            Capsule()
                .fill(Color.surfaceVariant.opacity(0.4))
        )
    }
}
