//
//  ServiceCategoryCard.swift
//  Carely
//
//  Created by Mina on 22/07/2026.
//

import SwiftUI

struct ServiceCategoryCard: View {
    let category: ServiceCategory
    let onTap: () -> Void
    
    private var subtitleText: String {
        let trimmed = category.subtitle.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? "Professional healthcare services" : trimmed
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
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .multilineTextAlignment(.leading)
                    
                    Text(subtitleText)
                        .carelyText(style: CarelyTextStyle.bodySmall)
                        .foregroundColor(.secondaryFont)
                        .lineLimit(2)
                        .truncationMode(.tail)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Spacer(minLength: 0)
            }
            .padding(Spacing.s16)
            .frame(maxWidth: .infinity, minHeight: 165, maxHeight: 165, alignment: .topLeading)
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
    LazyVGrid(
        columns: [GridItem(.flexible(), spacing: Spacing.s12), GridItem(.flexible(), spacing: Spacing.s12)],
        spacing: Spacing.s12
    ) {
        ServiceCategoryCard(
            category: ServiceCategory(
                id: "1",
                title: "Nursing Care",
                subtitle: "Professional home care & post-operative support",
                iconName: "cross.case.fill",
                layout: .standard,
                accent: .neutral,
                imageUrl: nil
            ),
            onTap: {}
        )
        ServiceCategoryCard(
            category: ServiceCategory(
                id: "2",
                title: "Physiotherapy & Rehabilitation",
                subtitle: "Restore mobility and recover from injuries at home",
                iconName: "figure.walk",
                layout: .standard,
                accent: .neutral,
                imageUrl: nil
            ),
            onTap: {}
        )
    }
    .padding()
    .background(Color.backGround)
}
