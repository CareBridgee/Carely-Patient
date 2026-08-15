//
//  ChatHeaderView.swift
//  Carely
//
//  Created by Mohamed Ayman on 31/07/2026.
//

import SwiftUI

struct ChatHeaderView: View {
    var onDismiss: (() -> Void)? = nil
    var onReset: (() -> Void)? = nil

    var body: some View {
        HStack(spacing: Spacing.s12) {
            if let onDismiss = onDismiss {
                Button(action: onDismiss) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color.brandPrimary)
                }
            }

            ZStack {
                Circle()
                    .fill(Color.brandPrimary.opacity(0.1))
                    .frame(width: 36, height: 36)

                Image(systemName: "sparkles")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color.brandPrimary)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text("AI Assistant")
                    .carelyText(style: .bodyRegular, weight: .bold)
                    .foregroundColor(Color.brandPrimary)

                HStack(spacing: 4) {
                    Circle()
                        .fill(Color.success)
                        .frame(width: 6, height: 6)

                    Text("Online & Ready to help")
                        .carelyText(style: .caption, weight: .medium)
                        .foregroundColor(Color.secondaryFont)
                }
            }

            Spacer()

            if let onReset = onReset {
                Button(action: {
                    onReset()
                }) {
                    HStack(spacing: Spacing.s4) {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.system(size: 13, weight: .medium))
                        Text("Start over")
                            .carelyText(style: .caption, weight: .semiBold)
                    }
                    .foregroundColor(Color.secondaryFont)
                    .padding(.horizontal, Spacing.s12)
                    .padding(.vertical, Spacing.s8)
                    .background(Color.backGround)
                    .cornerRadius(12)
                }
            }
        }
        .padding(.horizontal, Spacing.s20)
        .padding(.vertical, Spacing.s12)
        .background(Color.surface)
    }
}

