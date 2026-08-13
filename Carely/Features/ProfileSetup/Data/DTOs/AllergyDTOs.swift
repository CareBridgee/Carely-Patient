//
//  AllergyDTOs.swift
//  Carely
//

import Foundation

// MARK: - GET /api/v1/allergies Response DTO
struct SystemAllergyDTO: Decodable {
    let id: String
    let name: String
    let type: String
    let source: String?
    let createdAt: String?
}

// MARK: - GET /api/v1/profiles/{profileId}/allergies Response DTO
struct ProfileAllergyDTO: Decodable {
    let id: String
    let profileId: String
    let allergyId: String
    let allergyName: String?
    let allergyType: String?
    let createdAt: String?
}

// MARK: - POST /api/v1/profiles/{profileId}/allergies Request DTO
struct AddAllergyRequestDTO: Encodable {
    let allergyId: String
    let name: String
    let type: String
}
