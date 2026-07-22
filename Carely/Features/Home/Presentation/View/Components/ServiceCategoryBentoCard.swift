//
//  ServiceCategoryBentoCard.swift
//  Carely
//
//  Created by Mina on 22/07/2026.
//

import SwiftUI

struct ServiceCategoryBentoCard: View {
    let category: ServiceCategory
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            content
                .padding(Spacing.s20)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .background(style.background)
                .clipShape(RoundedRectangle.carely(Radius.r24))
                .carelyShadow(.sm)
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var content: some View {
        switch category.layout {
        case .standard:
            VStack(alignment: .leading, spacing: Spacing.s8) {
                iconBadge(size: 40, iconScale: 18)
                titleText(style: .bodySmall, lineLimit: 1)
                subtitleText(lineLimit: 1)
            }

        case .featured:
            VStack(alignment: .leading, spacing: Spacing.s12) {
                iconBadge(size: 48, iconScale: 22)
                titleText(style: .heading3, lineLimit: 2)
                Spacer(minLength: Spacing.s12)
                subtitleText(lineLimit: 2)
            }

        case .wide:
            HStack(spacing: Spacing.s16) {
                iconBadge(size: 56, iconScale: 26)
                VStack(alignment: .leading, spacing: Spacing.s4) {
                    titleText(style: .heading3, lineLimit: 1)
                    subtitleText(lineLimit: 1)
                }
                Spacer(minLength: Spacing.s8)
                Image(systemName: "chevron.right")
                    .foregroundColor(style.subtitle)
                    .layoutPriority(1)
            }
        }
    }

    @ViewBuilder
    private func titleText(style textStyle: CarelyTextStyle, lineLimit: Int) -> some View {
        Text(category.title)
            .carelyText(style: textStyle, weight: .semiBold)
            .foregroundColor(style.foreground)
            .lineLimit(lineLimit)
            .minimumScaleFactor(0.85)
            .fixedSize(horizontal: false, vertical: true)
    }

    @ViewBuilder
    private func subtitleText(lineLimit: Int) -> some View {
        Text(category.subtitle)
            .carelyText(style: .caption)
            .foregroundColor(style.subtitle)
            .lineLimit(lineLimit)
            .minimumScaleFactor(0.85)
            .fixedSize(horizontal: false, vertical: true)
    }

    @ViewBuilder
    private func iconBadge(size: CGFloat, iconScale: CGFloat) -> some View {
        Image(systemName: category.iconName)
            .font(.system(size: iconScale))
            .foregroundColor(style.icon)
            .frame(width: size, height: size)
            .background(style.iconBackground)
            .clipShape(RoundedRectangle.carely(Radius.r16))
            .fixedSize()
    }

    private var style: Style {
        Style(accent: category.accent)
    }

    private struct Style {
        let accent: ServiceCategoryAccent

        var background: Color {
            switch accent {
            case .primary: return .onBankContainer
            case .secondary: return .mintSurface
            case .tertiary: return .tint
            case .neutral: return .surface
            }
        }

        var foreground: Color {
            switch accent {
            case .primary, .tertiary: return .onPrimary
            case .secondary, .neutral: return .primaryFont
            }
        }

        var subtitle: Color {
            switch accent {
            case .primary, .tertiary: return .onPrimary.opacity(0.8)
            default: return .secondaryFont
            }
        }

        var iconBackground: Color {
            switch accent {
            case .primary, .tertiary: return .onPrimary.opacity(0.18)
            default: return .primaryContainer.opacity(0.12)
            }
        }

        var icon: Color {
            switch accent {
            case .primary, .tertiary: return .onPrimary
            default: return .brandPrimary
            }
        }
    }
}

#Preview {
    VStack(spacing: Spacing.s12) {
        HStack(spacing: Spacing.s12) {
            ServiceCategoryBentoCard(
                category: ServiceCategory(id: "1", title: "General Nursing", subtitle: "Routine checks & wellness", iconName: "cross.case.fill", layout: .featured, accent: .primary)
            )
            .frame(height: 280)

            VStack(spacing: Spacing.s12) {
                ServiceCategoryBentoCard(
                    category: ServiceCategory(id: "2", title: "Injection", subtitle: "Home dosage", iconName: "cross.vial.fill", layout: .standard, accent: .neutral)
                )
                ServiceCategoryBentoCard(
                    category: ServiceCategory(id: "3", title: "Physical Therapy for Home Recovery", subtitle: "Mobility aid and long recovery support", iconName: "figure.walk", layout: .standard, accent: .neutral)
                )
            }
            .frame(height: 280)
        }
        ServiceCategoryBentoCard(
            category: ServiceCategory(id: "4", title: "Lab Tests", subtitle: "Sample collection at home", iconName: "testtube.2", layout: .wide, accent: .secondary)
        )
        .frame(height: 96)
    }
    .padding()
    .background(Color.backGround)
}
