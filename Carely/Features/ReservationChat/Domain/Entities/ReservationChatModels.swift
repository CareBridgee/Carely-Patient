//
//  ChatModels.swift
//  Carely
//

import Foundation

struct ChatMessageRequest: Codable {
    let content: String
}

struct ChatMessageResponse: Codable, Identifiable, Equatable {
    let id: String
    let serviceRequestId: String
    let senderUserId: String
    let senderName: String
    let senderPhone: String
    let content: String
    let createdAt: String?
}
