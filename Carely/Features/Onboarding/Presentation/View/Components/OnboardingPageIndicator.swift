//
//  OnboardingPageIndicator.swift
//  Carely
//

import SwiftUI

struct OnboardingPageIndicator: View {
    let pageCount: Int
    let currentPage: Int
    
    var body: some View {
        HStack(spacing: Spacing.s8) {
            ForEach(0..<pageCount, id: \.self) { index in
                let isActive = index == currentPage
                Capsule()
                    .fill(isActive ? Color.brandPrimary : Color.disable)
                    .frame(width: isActive ? 24 : 8, height: 8)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isActive)
            }
        }
    }
}

#Preview {
    OnboardingPageIndicator(pageCount: 4, currentPage: 1)
}
