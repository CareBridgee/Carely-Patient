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
    let description: String
    let imageUrl: String
    let category: String
    let minimumDurationMinutes: Int
    let estimatedDurationMinutes: Int
    let basePrice: Double
    let includedItems: [String]
    let preparationNote: String
    let createdAt: Date
}
