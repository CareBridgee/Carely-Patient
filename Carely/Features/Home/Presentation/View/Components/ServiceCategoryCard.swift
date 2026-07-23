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
                // Top Circular Icon Badge
                ZStack {
                    Circle()
                        .fill(Color.surfaceVariant)
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: category.iconName)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color.onBankContainer)
                }
                
                VStack(alignment: .leading, spacing: Spacing.s4) {
                    Text(category.title)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text(category.subtitle)
                        .carelyText(style: CarelyTextStyle.bodySmall)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer(minLength: 0)
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 140, alignment: .topLeading)
            .background(Color.white)
            .cornerRadius(Radius.r20)
            .carelyShadow(.sm)
        }
        .buttonStyle(.plain)
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
