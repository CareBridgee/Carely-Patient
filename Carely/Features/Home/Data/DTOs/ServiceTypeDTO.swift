//
//  ServiceTypeDTO.swift
//  Carely
//
//  Created by Mina on 28/07/2026.
//

import Foundation

struct ServiceTypeDTO: Decodable {
    let id: String
    let name: String
    let category: String
    let basePrice: Double
    let minimumDurationMinutes: Int
    let imageUrl: String?
    let description: String?
    let preparationNote: String?
    let estimatedDurationMinutes: Int?
    let includedItems: [String]?
    let createdAt: Date?
}
