//
//  NotificationResponseDTO.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 04/08/2026.
//


import Foundation

struct NotificationResponseDTO: Decodable {
    let id: String
    let userId: String
    let title: String
    let message: String
    let type: String
    let isRead: Bool
    let relatedEntityType: String?
    let relatedEntityId: String?
    let createdAt: String
    let updatedAt: String?
}