//
//  UpcomingBookingCard.swift
//  Carely
//
//  Created by Mina on 22/07/2026.
//

import SwiftUI

struct UpcomingBookingCard: View {
    let booking: UpcomingBooking
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.s16) {
                avatar
                
                VStack(alignment: .leading, spacing: Spacing.s4) {
                    HStack {
                        Text(booking.providerName)
                            .carelyText(style: .bodySmall, weight: .semiBold)
                            .foregroundColor(.primaryFont)

                        Spacer()

                        StatusBadge(status: booking.status)
                    }

                    Text(booking.serviceName)
                        .carelyText(style: .bodySmall)
                        .foregroundColor(.secondaryFont)

                    HStack(spacing: Spacing.s4) {
                        Image(systemName: "calendar")
                        Text(booking.dateTimeText)
                    }
                    .carelyText(style: .caption)
                    .foregroundColor(.hint)
                }
            }
            .padding(Spacing.s16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.surface)
            .clipShape(RoundedRectangle.carely(Radius.r24))
            .carelyShadow(.sm)
        }
        .buttonStyle(.plain)
    }

    private var avatar: some View {
        Group {
            if let urlString = booking.providerImageUrl, let url = URL(string: urlString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .tint(Color.brandPrimary)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        fallbackIcon
                    @unknown default:
                        fallbackIcon
                    }
                }
            } else {
                fallbackIcon
            }
        }
        .frame(width: 48, height: 48)
        .background(Color.primaryContainer.opacity(0.3))
        .clipShape(RoundedRectangle.carely(Radius.r16))
    }

    private var fallbackIcon: some View {
        Image(systemName: booking.providerImageName)
            .resizable()
            .scaledToFit()
            .frame(width: 28, height: 28)
            .foregroundColor(.brandPrimary)
    }
}

private struct StatusBadge: View {
    let status: BookingStatus

    var body: some View {
        Text(status.rawValue)
            .carelyText(style: .caption, weight: .medium)
            .foregroundColor(foregroundColor)
            .padding(.horizontal, Spacing.s8)
            .padding(.vertical, 2)
            .background(backgroundColor)
            .clipShape(Capsule())
    }

    private var backgroundColor: Color {
        switch status {
        case .confirmed: return .successContainer
        case .pending: return .warningContainer
        case .completed: return .infoContainer
        }
    }

    private var foregroundColor: Color {
        switch status {
        case .confirmed: return .onSuccessContainer
        case .pending: return .onWarningContainer
        case .completed: return .onInfoContainer
        }
    }
}

//#Preview {
//    VStack(spacing: Spacing.s12) {
//        UpcomingBookingCard(
//            booking: UpcomingBooking(
//                id: "1",
//                providerName: "Nurse Sarah Jenkins",
//                providerImageName: "person.crop.circle.fill",
//                serviceName: "General Nursing Care",
//                status: .confirmed,
//                dateTimeText: "Today, 02:30 PM"
//            )
//        )
//        UpcomingBookingCard(
//            booking: UpcomingBooking(
//                id: "2",
//                providerName: "Dr. Amina Youssef",
//                providerImageName: "person.crop.circle.fill",
//                serviceName: "Physical Therapy Session",
//                status: .pending,
//                dateTimeText: "Tomorrow, 10:00 AM"
//            )
//        )
//        UpcomingBookingCard(
//            booking: UpcomingBooking(
//                id: "3",
//                providerName: "Dr. Amina Youssef",
//                providerImageName: "person.crop.circle.fill",
//                serviceName: "Physical Therapy Session",
//                status: .completed,
//                dateTimeText: "Tomorrow, 10:00 AM"
//            )
//        )
//    }
//    .padding()
//    .background(Color.backGround)
//}
