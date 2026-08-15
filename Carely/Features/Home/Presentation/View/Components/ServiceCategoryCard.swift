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
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: Spacing.s12) {
                // Top Circular Icon Badge / Image
                ZStack {
                    Circle()
                        .fill(Color.surfaceVariant)
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
                                    .clipShape(Circle())
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
                    
                    Text(category.subtitle)
                        .carelyText(style: CarelyTextStyle.bodySmall)
                        .foregroundColor(.secondaryFont)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer(minLength: 0)
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 140, alignment: .topLeading)
            .background(Color.surface)
            .cornerRadius(Radius.r20)
            .carelyShadow(.sm)
        }
        .buttonStyle(.plain)
    }

    private var fallbackIcon: some View {
        Image(systemName: category.iconName)
            .font(.system(size: 20, weight: .semibold))
            .foregroundColor(Color.onBankContainer)
    }
}

//#Preview {
//    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: Spacing.s12) {
//        ServiceCategoryCard(
//            category: ServiceCategory(
//                id: "1",
//                title: "Injection",
//                subtitle: "Home dosage",
//                iconName: "cross.vial.fill",
//                layout: .standard,
//                accent: .neutral
//            ),
//            onTap: {}
//        )
//        ServiceCategoryCard(
//            category: ServiceCategory(
//                id: "2",
//                title: "Physical Therapy",
//                subtitle: "Mobility aid",
//                iconName: "figure.walk",
//                layout: .standard,
//                accent: .neutral
//            ),
//            onTap: {}
//        )
//    }
//    .padding()
//    .background(Color.backGround)
//}
