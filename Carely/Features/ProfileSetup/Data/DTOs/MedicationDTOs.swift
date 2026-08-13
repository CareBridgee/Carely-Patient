//
//  MedicationDTOs.swift
//  Carely
//

import Foundation

// MARK: - GET & POST /api/v1/profiles/{profileId}/medications Response DTO
struct ProfileMedicationDTO: Decodable {
    let id: String
    let profileId: String
    let medicationId: String
    let medicationName: String?
    let createdAt: String?
}

// MARK: - POST /api/v1/profiles/{profileId}/medications Request DTO
struct AddMedicationRequestDTO: Encodable {
    let name: String
}
