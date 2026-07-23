//
//  AIAssessmentBannerView.swift
//  Carely
//
//  Created by Mina on 22/07/2026.
//

import SwiftUI
 
struct AIAssessmentBannerView: View {
    var onStartChatTapped: (() -> Void)
 
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.s8) {
            HStack(spacing: Spacing.s4) {
                Image(systemName: "sparkles")
                Text("AI POWERED")
                    .carelyText(style: .caption, weight: .semiBold)
            }
            .foregroundColor(.onPrimary.opacity(0.85))
 
            Text("AI Health Assessment")
                .carelyText(style: .heading2, weight: .bold)
                .foregroundColor(.onPrimary)
 
            Text("Describe your symptoms, get matched instantly with specialists.")
                .carelyText(style: .bodyRegular)
                .foregroundColor(.onPrimary.opacity(0.9))
                .fixedSize(horizontal: false, vertical: true)
 
            PrimaryButton(
                colorOfBackground: Color.white,
                colorOfForground: Color.onPrimaryContainer,
                title: "Start Chat",
                size: .medium,
                icon: "message.fill",
                iconPosition: .trailing,
                isFullWidth: false
            ) {
                onStartChatTapped()
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
//    AIAssessmentBannerView(){}
//        .padding()
//        .background(Color.backGround)
//}
// 
