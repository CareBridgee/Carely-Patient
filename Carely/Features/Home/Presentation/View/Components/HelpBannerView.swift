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
        VStack(alignment: .leading, spacing: Spacing.s12) {
            Text("Not sure what you need?")
                .carelyText(style: .heading3, weight: .semiBold)
                .foregroundColor(.primaryFont)
 
            Text("Chat with our care coordinator for a personalized recommendation.")
                .carelyText(style: .bodyRegular)
                .foregroundColor(.secondaryFont)
 
            PrimaryButton(
                title: "Consult Now",
                isFullWidth: false,
                action: onConsultTapped
            )
        }
        .padding(Spacing.s24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.mintSurface)
        .clipShape(RoundedRectangle.carely(Radius.r24))
    }
}
 
//#Preview {
//    HelpBannerView()
//        .padding()
//        .background(Color.backGround)
//}
