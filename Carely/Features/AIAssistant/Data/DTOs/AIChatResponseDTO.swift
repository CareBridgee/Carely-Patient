//
//  AIChatResponseDTO.swift
//  Carely
//
//  Created by Mohamed Ayman on 31/07/2026.
//

import Foundation

enum ChatMessageTypeDTO: String, Codable, Equatable {
    case text = "TEXT"
    case input = "INPUT"
    case confirm = "CONFIRM"
    case urgent = "URGENT"
    case error = "ERROR"

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)
        self = ChatMessageTypeDTO(rawValue: raw) ?? .text
    }
}

struct ReservationDraftDTO: Codable, Equatable {
    let serviceTypeId: String?
    let serviceTypeName: String?
    let preferredDate: String?
    let preferredTime: String?
    let serviceDescription: String?
    let complete: Bool?
}

struct UrgencySignalDTO: Codable, Equatable {
    let urgent: Bool?
    let level: String?
    let advice: String?
}

struct ChatTurnResponseDTO: Decodable, Equatable {
    let messageType: ChatMessageTypeDTO
    let reply: String
    let draft: ReservationDraftDTO?
    let urgency: UrgencySignalDTO?

    enum CodingKeys: String, CodingKey {
        case messageType
        case reply
        case draft
        case urgency
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.messageType = try container.decodeIfPresent(ChatMessageTypeDTO.self, forKey: .messageType) ?? .text
        self.reply = try container.decodeIfPresent(String.self, forKey: .reply) ?? ""
        self.draft = try container.decodeIfPresent(ReservationDraftDTO.self, forKey: .draft)
        self.urgency = try container.decodeIfPresent(UrgencySignalDTO.self, forKey: .urgency)
    }

    init(
        messageType: ChatMessageTypeDTO,
        reply: String,
        draft: ReservationDraftDTO? = nil,
        urgency: UrgencySignalDTO? = nil
    ) {
        self.messageType = messageType
        self.reply = reply
        self.draft = draft
        self.urgency = urgency
    }
}

