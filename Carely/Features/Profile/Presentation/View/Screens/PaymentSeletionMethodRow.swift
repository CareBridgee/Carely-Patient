//
//  PaymentMethodRow.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 16/08/2026.
//

import SwiftUI


struct PaymentSeletionMethodRow: View {
    let title: String
    let subtitle: String
    let icon: String
    let isSelected: Bool
    let isEnabled: Bool
    
    var body: some View {
        HStack(spacing: Spacing.s16) {
            Circle()
                .fill(isEnabled ? Color.primaryContainer.opacity(0.3) : Color.surfaceVariant)
                .frame(width: 44, height: 44)
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundColor(isEnabled ? .brandPrimary : .hint)
                )
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .carelyText(style: .bodyRegular, weight: .semiBold)
                    .foregroundColor(isEnabled ? .primaryFont : .hint)
                Text(subtitle)
                    .carelyText(style: .caption)
                    .foregroundColor(isEnabled ? .secondaryFont : .disable)
            }
            
            Spacer()
            
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 22))
                    .foregroundColor(.brandPrimary)
            } else {
                Image(systemName: "chevron.right")
                    .foregroundColor(.hint)
            }
        }
        .padding(Spacing.s16)
        .background(Color.surface)
        .clipShape(RoundedRectangle.carely(Radius.r16))
        .overlay(
            RoundedRectangle.carely(Radius.r16)
                .stroke(isSelected ? Color.brandPrimary : Color.divider, lineWidth: isSelected ? 1.5 : 1)
        )
        .opacity(isEnabled ? 1.0 : 0.6)
    }
}
