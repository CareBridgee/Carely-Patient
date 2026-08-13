//
//  ReservationDraftCard.swift
//  Carely
//
//  Created by Mohamed Ayman on 08/08/2026.
//

import SwiftUI

struct ReservationDraftCard: View {
    let draft: ReservationDraft
    let onBookNow: (ReservationDraft) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.s12) {
            HStack {
                HStack(spacing: Spacing.s8) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 12, weight: .bold))
                    Text("Recommended Service")
                        .carelyText(style: .caption, weight: .bold)
                }
                .foregroundColor(Color.brandPrimary)
                .padding(.horizontal, Spacing.s12)
                .padding(.vertical, Spacing.s4)
                .background(Color.brandPrimary.opacity(0.12))
                .cornerRadius(10)

                Spacer()

                if draft.complete {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.green)
                        Text("Ready")
                            .carelyText(style: .caption, weight: .semiBold)
                            .foregroundColor(.green)
                    }
                }
            }

            if let serviceName = draft.serviceTypeName, !serviceName.isEmpty {
                VStack(alignment: .leading, spacing: Spacing.s4) {
                    Text(serviceName)
                        .carelyText(style: .heading2, weight: .bold)
                        .foregroundColor(Color.primaryFont)
                }
            }

            Divider()
                .padding(.vertical, Spacing.s4)

            if draft.complete {
                Button(action: { onBookNow(draft) }) {
                    HStack {
                        Image(systemName: "calendar.badge.plus")
                            .font(.system(size: 16, weight: .semibold))
                        Text("Proceed to Booking")
                            .carelyText(style: .bodyRegular, weight: .bold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(Color.brandPrimary)
                    .cornerRadius(14)
                }
                .buttonStyle(PlainButtonStyle())
            } else {
                Text("Answer the questions above or tell the assistant if you want to proceed now.")
                    .carelyText(style: .caption, weight: .regular)
                    .foregroundColor(Color.secondaryFont)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(Spacing.s16)
        .background(Color.surface)
        .cornerRadius(18)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.brandPrimary.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
    }

    private func detailChip(icon: String, title: String) -> some View {
        HStack(spacing: Spacing.s4) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundColor(Color.brandPrimary)

            Text(title)
                .carelyText(style: .caption, weight: .semiBold)
                .foregroundColor(Color.primaryFont)
        }
        .padding(.horizontal, Spacing.s12)
        .padding(.vertical, Spacing.s8)
        .background(Color.brandPrimary.opacity(0.08))
        .cornerRadius(8)
    }
}
