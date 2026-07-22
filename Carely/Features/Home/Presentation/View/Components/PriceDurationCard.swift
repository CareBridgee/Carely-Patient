//
//  PriceDurationCard.swift
//  Carely
//
//  Created by Mina on 22/07/2026.
//

import SwiftUI
 
struct PriceDurationCard: View {
    let iconName: String
    let label: String
    let value: String
    var tintColor: Color = .brandPrimary
 
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.s12) {
            Image(systemName: iconName)
                .foregroundColor(tintColor)
 
            VStack(alignment: .leading, spacing: Spacing.s4) {
                Text(label)
                    .carelyText(style: .caption)
                    .foregroundColor(.secondaryFont)
                Text(value)
                    .carelyText(style: .heading3, weight: .semiBold)
                    .foregroundColor(tintColor)
            }
        }
        .padding(Spacing.s16)
        .frame(maxWidth: .infinity, minHeight: 112, alignment: .topLeading)
        .background(Color.surface)
        .overlay(
            RoundedRectangle.carely(Radius.r24)
                .stroke(Color.divider.opacity(0.4), lineWidth: 1)
        )
        .clipShape(RoundedRectangle.carely(Radius.r24))
        .carelyShadow(.sm)
    }
}
 
#Preview {
    HStack(spacing: Spacing.s12) {
        PriceDurationCard(iconName: "creditcard.fill", label: "Starting from", value: "$189.00")
        PriceDurationCard(iconName: "clock.fill", label: "Duration", value: "45-60 min", tintColor: .tint)
    }
    .padding()
    .background(Color.backGround)
}
