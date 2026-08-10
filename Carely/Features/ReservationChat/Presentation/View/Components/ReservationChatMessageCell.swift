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
                        .foregroundColor(.gray)
                }
                
                Text(message.content)
                    .padding(12)
                    .background(isCurrentUser ? Color.blue : Color.gray.opacity(0.2))
                    .foregroundColor(isCurrentUser ? .white : .primary)
                    .cornerRadius(16)
                
                Text(formatDate(message.createdAt))
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            
            if !isCurrentUser {
                Spacer()
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
    
    private func formatDate(_ dateString: String) -> String {
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
