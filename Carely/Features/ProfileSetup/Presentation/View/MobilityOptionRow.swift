//
//  MobilityOptionRow.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 20/07/2026.
//


import SwiftUI

struct MobilityOptionRow: View {
    let status: MobilityStatus
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: Spacing.s12) {
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.brandPrimary.opacity(0.12) : Color.surfaceVariant)
                        .frame(width: Spacing.s40, height: Spacing.s40)

                    Image(systemName: status.icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: IconSize.s20, height: IconSize.s20)
                        .foregroundColor(isSelected ? .brandPrimary : .hint)
                }

                VStack(alignment: .leading, spacing: Spacing.s2) {
                    Text(status.title)
                        .carelyText(style: .bodyRegular, weight: .semiBold)
                        .foregroundColor(.primaryFont)

                    Text(status.subtitle)
                        .carelyText(style: .bodySmall, weight: .regular)
                        .foregroundColor(.secondaryFont)
                }

                Spacer(minLength: .zero)
            }
            .padding(Spacing.s16)
            .background(Color.surface)
            .clipShape(RoundedRectangle.carely(Radius.r16))
            .overlay(
                RoundedRectangle.carely(Radius.r16)
                    .stroke(isSelected ? Color.brandPrimary : Color.divider, lineWidth: isSelected ? 1.5 : 1)
            )
        }
        .buttonStyle(.plain)
    }
}
