//
//  HelpBannerView.swift
//  Carely
//
//  Created by Mina on 22/07/2026.
//

import SwiftUI
 
struct HelpBannerView: View {
    var onConsultTapped: () -> Void = {}
 
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.s8) {
            HStack(spacing: Spacing.s4) {
                Image(systemName: "sparkles")
                Text("AI POWERED")
                    .carelyText(style: .caption, weight: .semiBold)
            }
            .foregroundColor(.onPrimary.opacity(0.85))

            Text("Not sure what you need?")
                .carelyText(style: .heading2, weight: .bold)
                .foregroundColor(.onPrimary)

            Text("Chat with our AI care coordinator for personalized recommendations.")
                .carelyText(style: .bodyRegular)
                .foregroundColor(.onPrimary.opacity(0.9))
                .fixedSize(horizontal: false, vertical: true)

            PrimaryButton(
                colorOfBackground: Color.surface,
                colorOfForground: Color.brandPrimary,
                title: "Consult Now",
                size: .medium,
                icon: "message.fill",
                iconPosition: .trailing,
                isFullWidth: false
            ) {
                onConsultTapped()
            }
            .padding(.top, Spacing.s8)
        }
        .padding(Spacing.s24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                colors: [Color.tint, Color.tint],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .clipShape(RoundedRectangle.carely(Radius.r24))
        .carelyShadow(.md)
    }
}
 
//#Preview {
//    HelpBannerView()
//        .padding()
//        .background(Color.backGround)
//}
