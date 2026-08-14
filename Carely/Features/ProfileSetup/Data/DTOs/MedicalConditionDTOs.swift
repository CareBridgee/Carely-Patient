//
//  MedicalConditionDTOs.swift
//  Carely
//

import Foundation

// MARK: - GET /api/v1/medical-conditions Response DTO
struct SystemMedicalConditionDTO: Decodable {
    let id: String
    let name: String
    let description: String?
    let source: String?
    let createdAt: String?
}

// MARK: - GET /api/v1/profiles/{profileId}/medical-conditions Response DTO
struct ProfileMedicalConditionDTO: Decodable {
    let id: String
    let profileId: String
    let medicalConditionId: String
    let conditionName: String?
    let createdAt: String?
}

// MARK: - POST /api/v1/profiles/{profileId}/medical-conditions Request DTO
struct AddMedicalConditionRequestDTO: Encodable {
    let medicalConditionId: String
    let name: String
    let description: String
}
