//
//  Untitled.swift
//  Carely
//
//  Created by Mohamed Ayman on 22/07/2026.
//

import SwiftUI

// MARK: - FloatingTabBar

struct FloatingTabBar: View {

    @Binding var selectedTab: AppTab

    private let hapticGenerator = UIImpactFeedbackGenerator(style: .light)

    var body: some View {
        HStack(spacing: Spacing.s8) {
            ForEach(AppTab.allCases, id: \.self) { tab in
                tabButton(for: tab)
            }
        }
        .padding(.horizontal, Spacing.s12)
        .frame(height: 68)
        .background(
            Capsule()
                .fill(Color.brandPrimary)
                .shadow(color: Color.black.opacity(0.12), radius: Radius.r16, x: 0, y: 8)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 22)
    }

    // MARK: - Tab Button

    @ViewBuilder
    private func tabButton(for tab: AppTab) -> some View {
        let isSelected = selectedTab == tab

        Button {
            select(tab)
        } label: {
            HStack(spacing: Spacing.s8) {
                Image(systemName: tab.iconName)
                    .font(.system(size: 20, weight: .semibold))
                    .scaleEffect(isSelected ? 1.1 : 1.0)

                if isSelected {
                    Text(tab.title)
                        .carelyText(style: .bodySmall, weight: .bold)
                        .lineLimit(1)
                        .transition(.opacity.combined(with: .move(edge: .leading)))
                }
            }
            .foregroundColor(isSelected ? .white : .gray)
            .padding(.horizontal, isSelected ? Spacing.s16 : Spacing.s12)
            .frame(maxWidth: isSelected ? .infinity : nil)
            .frame(height: 48)
        }
        .buttonStyle(PlainButtonStyle())
        .frame(maxWidth: isSelected ? .infinity : nil)
    }

    // MARK: - Selection

    private func select(_ tab: AppTab) {
        guard tab != selectedTab else { return }
        hapticGenerator.impactOccurred()
        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
            selectedTab = tab
        }
    }
}
