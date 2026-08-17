//
//  PaymentMethodRow.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 22/07/2026.
//


import SwiftUI

import SwiftUI

struct PaymentMethodRow: View {
    let method: PaymentMethod
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: Spacing.s16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.mintSurface)
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: method.icon)
                        .font(.system(size: 24, weight: .regular))
                        .foregroundColor(.brandPrimary)
                }

                VStack(alignment: .leading, spacing: Spacing.s2) {
                    Text(method.title)
                        .carelyText(style: .bodyRegular, weight: .semiBold)
                        .foregroundColor(.primaryFont)
                }

                Spacer(minLength: .zero)

                Circle()
                    .strokeBorder(isSelected ? Color.brandPrimary : Color.divider, lineWidth: isSelected ? 6 : 1)
                    .frame(width: Spacing.s24, height: Spacing.s24)
            }
            .padding(Spacing.s16)
            .background(Color.surface)
            .clipShape(RoundedRectangle.carely(Radius.r16))
        }
        .buttonStyle(.plain)
    }
}
