//
//  ChatModels.swift
//  Carely
//
//  Created by Mohamed Ayman on 31/07/2026.
//

import Foundation

// MARK: - MessageSender

enum MessageSender: Equatable {
    case user
    case ai
}

// MARK: - MessageContent

enum MessageContent: Equatable {
    case text(String)
    case serviceRecommendation(ServiceRecommendation)
}

// MARK: - ServiceRecommendation

struct ServiceRecommendation: Identifiable, Equatable {
    let id: String
    let title: String
    let description: String
    let badgeText: String?
    let primaryButtonTitle: String
    let secondaryButtonTitle: String?
    let iconName: String
}

// MARK: - ChatMessage

struct ChatMessage: Identifiable, Equatable {
    let id: String
    let sender: MessageSender
    let content: MessageContent
    let timestamp: String
    let isSeen: Bool

    init(
        id: String = UUID().uuidString,
        sender: MessageSender,
        content: MessageContent,
        timestamp: String,
        isSeen: Bool = false
    ) {
        self.id = id
        self.sender = sender
        self.content = content
        self.timestamp = timestamp
        self.isSeen = isSeen
    }
}
