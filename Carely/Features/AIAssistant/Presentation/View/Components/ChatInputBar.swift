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
        HStack(spacing: Spacing.s12) {
            HStack(spacing: Spacing.s8) {
                TextField("Ask about your health profile...", text: $text)
                    .carelyText(style: .bodyRegular, weight: .regular)
                    .foregroundColor(Color.primaryFont)

                Button(action: { }) {
                    Image(systemName: "mic")
                        .font(.system(size: 18))
                        .foregroundColor(Color.secondaryFont)
                }
            }
            .padding(.horizontal, Spacing.s16)
            .frame(height: 52)
            .background(Color.backGround)
            .cornerRadius(26)

            Button(action: onSend) {
                ZStack {
                    Circle()
                        .fill(Color.brandPrimary)
                        .frame(width: 52, height: 52)

                    if isLoading {
                        ProgressView()
                            .tint(.white)
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                            .rotationEffect(.degrees(45))
                            .offset(x: -1, y: 1)
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(isLoading || text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding(.horizontal, Spacing.s20)
        .padding(.vertical, Spacing.s12)
        .background(Color.surface)
    }
}
