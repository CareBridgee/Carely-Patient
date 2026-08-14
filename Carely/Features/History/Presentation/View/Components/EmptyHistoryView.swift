//
//  EmptyHistoryView.swift
//  Carely
//
//  Created by Mina on 14/08/2026.
//

import SwiftUI
 
struct EmptyHistoryView: View {
    var onExploreServices: () -> Void = {}
 
    var body: some View {
        VStack(spacing: Spacing.s24) {
            ZStack {
                Circle()
                    .fill(Color.primaryContainer.opacity(0.35))
                    .frame(width: 128, height: 128)
 
                Circle()
                    .fill(Color.primaryContainer.opacity(0.6))
                    .frame(width: 96, height: 96)
 
                Image(systemName: "doc.text.fill")
                    .carelyText(style: .heading1)
                    .foregroundColor(.brandPrimary)
            }
 
            VStack(spacing: Spacing.s8) {
                Text("No history found")
                    .carelyText(style: .heading3, weight: .bold)
                    .foregroundColor(.primaryFont)
 
                Text("Your history is empty. Start your journey with us by booking a service today!")
                    .carelyText(style: .bodyRegular)
                    .foregroundColor(.secondaryFont)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
 
            PrimaryButton(
                title: "Explore Services",
                radius: Radius.pill,
                action: onExploreServices
            )
        }
        .padding(.horizontal, Spacing.s24)
    }
}
 
