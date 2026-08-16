//
//  ChatInputBar.swift
//  Carely
//
//  Created by Mohamed Ayman on 31/07/2026.
//

import SwiftUI

struct ChatInputBar: View {
    @Binding var text: String
    let isLoading: Bool
    let onSend: () -> Void

    var body: some View {
        HStack(alignment: .bottom, spacing: Spacing.s12) {

            // MARK: - Expanding text field container
            HStack(alignment: .bottom, spacing: Spacing.s8) {
                TextField("Ask about your health profile...", text: $text, axis: .vertical)
                    .lineLimit(1...5)
                    .carelyText(style: .bodyRegular, weight: .regular)
                    .foregroundColor(Color.primaryFont)
                    .tint(Color.brandPrimary)

                Button(action: { }) {
                    Image(systemName: "mic")
                        .font(.system(size: 18))
                        .foregroundColor(Color.secondaryFont)
                }
                .padding(.bottom, 1)
            }
            .padding(.horizontal, Spacing.s16)
            .padding(.vertical, Spacing.s12)
            .frame(minHeight: 48)

            // MARK: - Send button (fixed size, bottom-aligned)
            Button(action: onSend) {
                ZStack {
                    Circle()
                        .fill(Color.brandPrimary)
                        .frame(width: 48, height: 48)

                    if isLoading {
                        ProgressView()
                            .tint(Color.onPrimary)
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 18))
                            .foregroundColor(Color.onPrimary)
                            .rotationEffect(.degrees(45))
                            .offset(x: -1, y: 1)
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(isLoading || text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding(.horizontal, Spacing.s12)
        .padding(.vertical, Spacing.s8)
        .background(
            Capsule()
                .fill(Color.surface)
                .shadow(color: Color.black.opacity(0.12), radius: Radius.r16, x: 0, y: 8)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, Spacing.s8)
    }
}
