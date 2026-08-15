//
//  NotificationData.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 04/08/2026.
//


import SwiftUI

struct NotificationData: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let message: String
    let type: String
}

struct NotificationBannerView: View {
    let data: NotificationData
    var onDismiss: () -> Void
    var onTap: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: iconName(for: data.type))
                .foregroundColor(.onPrimary)
                .font(.system(size: 20))
                .padding(10)
                .background(Circle().fill(color(for: data.type)))

            VStack(alignment: .leading, spacing: 4) {
                Text(data.title)
                    .font(.headline)
                    .foregroundColor(.primaryFont)
                Text(data.message)
                    .font(.subheadline)
                    .foregroundColor(.secondaryFont)
                    .lineLimit(2)
            }
            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.surface)
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
        .padding(.horizontal, 16)
        .onTapGesture {
            onTap()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                onDismiss()
            }
        }
    }

    private func iconName(for type: String) -> String {
        switch type {
        case "BOOKING": return "calendar"
        case "MESSAGE": return "message.fill"
        case "PAYMENT": return "creditcard.fill"
        default: return "bell.fill"
        }
    }

    private func color(for type: String) -> Color {
        switch type {
        case "BOOKING": return .brandPrimary
        case "MESSAGE": return .success
        case "PAYMENT": return .amber
        default: return .hint
        }
    }
}