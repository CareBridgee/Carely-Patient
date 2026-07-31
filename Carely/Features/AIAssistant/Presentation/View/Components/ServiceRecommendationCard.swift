//
//  ServiceRecommendationCard.swift
//  Carely
//
//  Created by Mohamed Ayman on 31/07/2026.
//

import SwiftUI

struct ServiceRecommendationCard: View {
    let recommendation: ServiceRecommendation
    let onPrimaryAction: () -> Void
    let onSecondaryAction: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack {
                Color.brandPrimary.opacity(0.08)

                Image(systemName: recommendation.iconName)
                    .font(.system(size: 36, weight: .light))
                    .foregroundColor(Color.brandPrimary)
            }
            .frame(height: 120)

            VStack(alignment: .leading, spacing: Spacing.s12) {
                if let badge = recommendation.badgeText {
                    Text(badge.uppercased())
                        .carelyText(style: .caption, weight: .bold)
                        .foregroundColor(Color.brandPrimary)
                        .padding(.horizontal, Spacing.s12)
                        .padding(.vertical, Spacing.s4)
                        .background(Color.brandPrimary.opacity(0.15))
                        .cornerRadius(12)
                }

                Text(recommendation.title)
                    .carelyText(style: .heading2, weight: .bold)
                    .foregroundColor(Color.primaryFont)

                Text(recommendation.description)
                    .carelyText(style: .bodyRegular, weight: .regular)
                    .foregroundColor(Color.secondaryFont)
                    .fixedSize(horizontal: false, vertical: true)

                VStack(spacing: Spacing.s8) {
                    Button(action: onPrimaryAction) {
                        Text(recommendation.primaryButtonTitle)
                            .carelyText(style: .bodyRegular, weight: .bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(Color.brandPrimary)
                            .cornerRadius(14)
                    }
                    .buttonStyle(PlainButtonStyle())

                    if let secondaryTitle = recommendation.secondaryButtonTitle {
                        Button(action: onSecondaryAction) {
                            Text(secondaryTitle)
                                .carelyText(style: .bodyRegular, weight: .bold)
                                .foregroundColor(Color.primaryFont)
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                                .background(Color.brandPrimary.opacity(0.12))
                                .cornerRadius(14)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.top, Spacing.s8)
            }
            .padding(Spacing.s16)
        }
        .background(Color.surface)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 4)
    }
}
