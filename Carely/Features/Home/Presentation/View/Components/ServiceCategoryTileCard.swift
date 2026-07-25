////
////  ServiceCategoryTileCard.swift
////  Carely
////
////  Created by Mina on 22/07/2026.
////
//
//import SwiftUI
//
//struct ServiceCategoryTileCard: View {
//    let title: String
//    let subtitle: String
//    let iconName: String
//    let action: () -> Void
//
//    var body: some View {
//        Button(action: action) {
//            VStack(alignment: .leading, spacing: Spacing.s12) {
//                ZStack {
//                    RoundedRectangle(cornerRadius: Radius.r12)
//                        .fill(Color.brandPrimary.opacity(0.12))
//                        .frame(width: 48, height: 48)
//
//                    Image(systemName: iconName)
//                        .font(.system(size: 20, weight: .medium))
//                        .foregroundColor(.brandPrimary)
//                }
//
//                VStack(alignment: .leading, spacing: Spacing.s4) {
//                    Text(title)
//                        .carelyText(style: .bodyRegular, weight: .bold)
//                        .foregroundColor(.primaryFont)
//                        .multilineTextAlignment(.leading)
//
//                    Text(subtitle)
//                        .carelyText(style: .caption)
//                        .foregroundColor(.secondaryFont)
//                        .multilineTextAlignment(.leading)
//                }
//
//                Spacer(minLength: 0)
//            }
//            .padding(Spacing.s16)
//            .frame(maxWidth: .infinity, alignment: .leading)
//            .background(Color.surface)
//            .clipShape(RoundedRectangle.carely(Radius.r20))
//            .carelyShadow(.sm)
//        }
//        .buttonStyle(PlainButtonStyle())
//    }
//}
//
//#Preview {
//    ServiceCategoryTileCard(
//        title: "Injection",
//        subtitle: "Home dosage",
//        iconName: "syringe",
//        action: {}
//    )
//    .padding()
//    .background(Color.backGround)
//}
