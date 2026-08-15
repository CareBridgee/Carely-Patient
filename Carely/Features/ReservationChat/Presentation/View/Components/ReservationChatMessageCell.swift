//
//  ReservationChatMessageCell.swift
//  Carely
//

import SwiftUI

struct ReservationChatMessageCell: View {
    let message: ChatMessageResponse
    let isCurrentUser: Bool
    
    var body: some View {
        HStack {
            if isCurrentUser {
                Spacer()
            }
            
            VStack(alignment: isCurrentUser ? .trailing : .leading, spacing: 4) {
                if !isCurrentUser {
                    Text(message.senderName)
                        .font(.caption)
                        .foregroundColor(.secondaryFont)
                }
                
                Text(message.content)
                    .padding(12)
                    .background(isCurrentUser ? Color.brandPrimary : Color.surfaceVariant)
                    .foregroundColor(isCurrentUser ? Color.onPrimary : Color.primaryFont)
                    .cornerRadius(16)
                
                Text(formatDate(message.createdAt))
                    .font(.caption2)
                    .foregroundColor(.secondaryFont)
            }
            
            if !isCurrentUser {
                Spacer()
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
    
    private func formatDate(_ dateString: String?) -> String {
        guard let dateString = dateString else { return "" }
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        if let date = formatter.date(from: dateString) ?? ISO8601DateFormatter().date(from: dateString) {
            let displayFormatter = DateFormatter()
            displayFormatter.timeStyle = .short
            return displayFormatter.string(from: date)
        }
        return dateString // Fallback if parsing fails
    }
}
