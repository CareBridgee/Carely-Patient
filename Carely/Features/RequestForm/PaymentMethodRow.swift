//
//  PaymentMethodRow.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 22/07/2026.
//


import SwiftUI

struct PaymentMethodRow: View {
    let method: PaymentMethod
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: Spacing.s12) {
                Image(systemName: method.icon)
                    .foregroundColor(.primaryFont)
                    .frame(width: Spacing.s24)

                VStack(alignment: .leading, spacing: Spacing.s2) {
                    Text(method.title)
                        .carelyText(style: .bodyRegular, weight: .semiBold)
                        .foregroundColor(.primaryFont)
                    Text(method.subtitle)
                        .carelyText(style: .caption, weight: .regular)
                        .foregroundColor(.secondaryFont)
                }

                Spacer(minLength: .zero)

                Circle()
                    .strokeBorder(isSelected ? Color.brandPrimary : Color.divider, lineWidth: isSelected ? 6 : 1)
                    .frame(width: Spacing.s20, height: Spacing.s20)
            }
            .padding(Spacing.s16)
            .background(Color.surface)
            .clipShape(RoundedRectangle.carely(Radius.r16))
        }
        .buttonStyle(.plain)
    }
}
