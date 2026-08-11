//
//  ChatMessageCell.swift
//  Carely
//
//  Created by Mohamed Ayman on 31/07/2026.
//

import SwiftUI

struct ChatMessageCell: View {
    let message: ChatMessage
    let onBookDraft: ((ReservationDraft) -> Void)?
    let onPrimaryRecommendationAction: ((ServiceRecommendation) -> Void)?
    let onSecondaryRecommendationAction: ((ServiceRecommendation) -> Void)?

    init(
        message: ChatMessage,
        onBookDraft: ((ReservationDraft) -> Void)? = nil,
        onPrimaryRecommendationAction: ((ServiceRecommendation) -> Void)? = nil,
        onSecondaryRecommendationAction: ((ServiceRecommendation) -> Void)? = nil
    ) {
        self.message = message
        self.onBookDraft = onBookDraft
        self.onPrimaryRecommendationAction = onPrimaryRecommendationAction
        self.onSecondaryRecommendationAction = onSecondaryRecommendationAction
    }

    private var isUser: Bool {
        message.sender == .user
    }

    var body: some View {
        VStack(alignment: isUser ? .trailing : .leading, spacing: Spacing.s8) {
            switch message.content {
            case .text(let text):
                textBubble(text)

            case .draftCard(let draft):
                ReservationDraftCard(
                    draft: draft,
                    onBookNow: { draft in
                        onBookDraft?(draft)
                    }
                )
                .frame(maxWidth: 320)

            case .serviceRecommendation(let recommendation):
                ServiceRecommendationCard(
                    recommendation: recommendation,
                    onPrimaryAction: { onPrimaryRecommendationAction?(recommendation) },
                    onSecondaryAction: { onSecondaryRecommendationAction?(recommendation) }
                )
                .frame(maxWidth: 320)

            case .emergencyCard(let advice, let phoneNumber):
                EmergencyCard(
                    advice: advice,
                    phoneNumber: phoneNumber
                )
                .frame(maxWidth: 320)
            }

            timestampAndStatusView
        }
        .frame(maxWidth: .infinity, alignment: isUser ? .trailing : .leading)
    }


    // MARK: - Sub-views

    private func textBubble(_ text: String) -> some View {
        Text(text)
            .carelyText(style: .bodyRegular, weight: .regular)
            .foregroundColor(isUser ? .white : Color.primaryFont)
            .padding(.horizontal, Spacing.s16)
            .padding(.vertical, Spacing.s12)
            .background(isUser ? Color.brandPrimary : Color.surface)
            .clipShape(ChatBubbleShape(radius: 18, corners: bubbleCorners))
            .shadow(color: isUser ? Color.clear : Color.black.opacity(0.02), radius: 4, x: 0, y: 2)
            .frame(maxWidth: 280, alignment: isUser ? .trailing : .leading)
    }

    private var bubbleCorners: UIRectCorner {
        isUser
            ? [.topLeft, .topRight, .bottomLeft]
            : [.topLeft, .topRight, .bottomRight]
    }

    private var timestampAndStatusView: some View {
        HStack(spacing: Spacing.s4) {
            Text(message.timestamp)
                .carelyText(style: .caption, weight: .regular)
                .foregroundColor(Color.secondaryFont)

            if isUser {
                HStack(spacing: -2) {
                    Image(systemName: "checkmark")
                    Image(systemName: "checkmark")
                }
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(message.isSeen ? Color.brandPrimary : Color.secondaryFont)

                Text(message.isSeen ? "Seen" : "Sent")
                    .carelyText(style: .caption, weight: .regular)
                    .foregroundColor(Color.secondaryFont)
            }
        }
        .padding(.horizontal, Spacing.s4)
    }
}

// MARK: - ChatBubbleShape

/// Renamed from RoundedCornerShape to avoid any potential name collision and make intent clearer.
struct ChatBubbleShape: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
