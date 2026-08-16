//
//  ActiveVisitFloatingBannerView.swift
//  Carely
//
//  Created by Mona Zarea on 15/08/2026.
//

import SwiftUI

struct ActiveVisitFloatingBannerView: View {
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: Spacing.s12) {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.brandPrimary)
                    .scaleEffect(0.95)
                    .frame(width: 28, height: 28)

                VStack(alignment: .leading, spacing: 3) {
                    Text("Active visit in progress...")
                        .carelyText(style: .bodyRegular, weight: .bold)
                        .foregroundColor(.brandPrimary)

                    Text("Tap to view current patient details.")
                        .carelyText(style: .caption, weight: .medium)
                        .foregroundColor(.brandPrimary.opacity(0.8))
                }

                Spacer()

                Circle()
                    .fill(Color.brandPrimary)
                    .frame(width: 36, height: 36)
                    .overlay(
                        Image(systemName: "arrow.right")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                    )
            }
            .padding(.horizontal, Spacing.s16)
            .padding(.vertical, Spacing.s16)
            .background(
                ZStack {
                    Color.surface
                    Color.brandPrimary.opacity(0.16)
                }
            )
            .cornerRadius(Radius.r20)
            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }
}
