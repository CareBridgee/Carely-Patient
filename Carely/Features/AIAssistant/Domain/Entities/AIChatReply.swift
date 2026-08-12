//
//  AIChatReply.swift
//  Carely
//
//  Created by Mohamed Ayman on 31/07/2026.
//

import Foundation

// MARK: - ChatMessageType

enum ChatMessageType: String, Equatable {
    case text = "TEXT"
    case input = "INPUT"
    case confirm = "CONFIRM"
    case urgent = "URGENT"
    case error = "ERROR"
}

// MARK: - ReservationDraft

struct ReservationDraft: Equatable, Hashable {
    let serviceTypeId: String?
    let serviceTypeName: String?
    let preferredDate: String?
    let preferredTime: String?
    let serviceDescription: String?
    let complete: Bool

    var formattedTime: String? {
        guard let preferredTime = preferredTime, !preferredTime.isEmpty else { return nil }
        let parts = preferredTime.split(separator: ":")
        if parts.count >= 2 {
            return "\(parts[0]):\(parts[1])"
        }
        return preferredTime
    }
}

// MARK: - UrgencySignal

struct UrgencySignal: Equatable {
    let urgent: Bool
    let level: String?
    let advice: String
}

// MARK: - ChatTurnResponse

struct ChatTurnResponse: Equatable {
    let messageType: ChatMessageType
    let reply: String
    let draft: ReservationDraft?
    let urgency: UrgencySignal?

    init(
        messageType: ChatMessageType = .text,
        reply: String,
        draft: ReservationDraft? = nil,
        urgency: UrgencySignal? = nil
    ) {
        self.messageType = messageType
        self.reply = reply
        self.draft = draft
        self.urgency = urgency
    }
}

struct AIChatReply {
    let text: String
}

