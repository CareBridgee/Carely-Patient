//
//  OnboardingCard.swift
//  Carely
//

import SwiftUI

struct OnboardingCard: View {
    let page: OnboardingPage
    
    var body: some View {
        ZStack {
            RoundedRectangle.carely(Radius.r24)
                .fill(Color.surface)
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
            
            GeometryReader { geo in
                page.illustration
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipShape(RoundedRectangle.carely(Radius.r24))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    OnboardingCard(page: OnboardingPage(id: 0, title: "Test", description: "Test Desc", illustration: Image.onboarding0))
        .frame(width: 300, height: 400)
}
