//
//  ServiceCategoryCard.swift
//  Carely
//
//  Created by Mina on 22/07/2026.
//

import SwiftUI

struct ServiceCategoryCard: View {
    let category: ServiceCategory
    var isBigger: Bool = false
    let onTap: () -> Void
    
    private var subtitleText: String? {
        if !category.subtitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return category.subtitle
        } else if isBigger {
            return "Professional care"
        } else {
            return nil
        }
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: Spacing.s12) {
                // Top Icon Badge / Image
                ZStack {
                    RoundedRectangle(cornerRadius: Radius.r12)
                        .fill(Color.brandPrimary.opacity(0.12))
                        .frame(width: 44, height: 44)
                    
                    if let imageUrlString = category.imageUrl, let url = URL(string: imageUrlString) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .tint(Color.brandPrimary)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 44, height: 44)
                                    .clipShape(RoundedRectangle(cornerRadius: Radius.r12))
                            case .failure:
                                fallbackIcon
                            @unknown default:
                                fallbackIcon
                            }
                        }
                    } else {
                        fallbackIcon
                    }
                }
                
                VStack(alignment: .leading, spacing: Spacing.s4) {
                    Text(category.title)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primaryFont)
                        .multilineTextAlignment(.leading)
                    
                    if isBigger, let text = subtitleText {
                        Text(text)
                            .carelyText(style: CarelyTextStyle.bodySmall)
                            .foregroundColor(.secondaryFont)
                            .multilineTextAlignment(.leading)
                    }
                }
            }
            .padding(Spacing.s16)
            .frame(maxWidth: .infinity, minHeight: isBigger ? 200 : 110, alignment: .leading)
            .background(Color.surface)
            .cornerRadius(Radius.r20)
            .overlay(
                RoundedRectangle(cornerRadius: Radius.r20)
                    .stroke(Color.black.opacity(0.06), lineWidth: 1)
            )
            .carelyShadow(.sm)
        }
        .buttonStyle(.plain)
    }

    private var fallbackIcon: some View {
        Image(systemName: category.iconName.isEmpty ? "photo" : category.iconName)
            .font(.system(size: 20, weight: .semibold))
            .foregroundColor(Color.brandPrimary)
    }
}

#Preview {
    HStack(alignment: .top, spacing: Spacing.s12) {
        VStack(spacing: Spacing.s12) {
            ServiceCategoryCard(
                category: ServiceCategory(
                    id: "1",
                    title: "injection",
                    subtitle: "Professional care",
                    iconName: "photo",
                    layout: .standard,
                    accent: .neutral,
                    imageUrl: nil
                ),
                isBigger: true,
                onTap: {}
            )
            ServiceCategoryCard(
                category: ServiceCategory(
                    id: "2",
                    title: "\"Test\"",
                    subtitle: "",
                    iconName: "photo",
                    layout: .standard,
                    accent: .neutral,
                    imageUrl: nil
                ),
                isBigger: false,
                onTap: {}
            )
        }
        VStack(spacing: Spacing.s12) {
            ServiceCategoryCard(
                category: ServiceCategory(
                    id: "3",
                    title: "injection",
                    subtitle: "",
                    iconName: "photo",
                    layout: .standard,
                    accent: .neutral,
                    imageUrl: nil
                ),
                isBigger: false,
                onTap: {}
            )
            ServiceCategoryCard(
                category: ServiceCategory(
                    id: "4",
                    title: "\"Test2\"",
                    subtitle: "Professional care",
                    iconName: "photo",
                    layout: .standard,
                    accent: .neutral,
                    imageUrl: nil
                ),
                isBigger: true,
                onTap: {}
            )
        }
    }
    .padding()
    .background(Color.backGround)
}
