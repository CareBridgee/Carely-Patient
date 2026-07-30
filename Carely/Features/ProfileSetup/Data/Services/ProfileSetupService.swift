//
//  ProfileSetupService.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 28/07/2026.
//

import Foundation

protocol ProfileSetupServiceProtocol {
    func fetchDefaultProfileId() async throws -> String
    func updateProfile(id: String, request: UpdateProfileRequestDTO) async throws
    func saveMedicalConditions(profileId: String, request: MedicalConditionRequestDTO) async throws
    func saveAllergies(profileId: String, request: AllergyRequestDTO) async throws
    func saveMedications(profileId: String, request: MedicationRequestDTO) async throws
    func saveMedicalHistory(profileId: String, request: MedicalHistoryRequestDTO) async throws
    func saveEmergencyContact(profileId: String, request: EmergencyContactRequestDTO) async throws
    func saveAddress(profileId: String, request: AddressRequestDTO) async throws
}

final class ProfileSetupServiceImpl: ProfileSetupServiceProtocol {
    private let networkClient: NetworkClientProtocol
    init(networkClient: NetworkClientProtocol) { self.networkClient = networkClient }

    private struct DefaultProfileResponse: Decodable { let id: String }

    func fetchDefaultProfileId() async throws -> String {
        let response: DefaultProfileResponse = try await networkClient.request(ProfileEndpoint.getDefaultProfile)
        return response.id
    }

    func updateProfile(id: String, request: UpdateProfileRequestDTO) async throws {
        try await networkClient.requestWithoutResponse(ProfileEndpoint.updateProfile(id: id, request: request))
    }
    
    func saveMedicalConditions(profileId: String, request: MedicalConditionRequestDTO) async throws {
        try await networkClient.requestWithoutResponse(ProfileEndpoint.saveMedicalConditions(profileId: profileId, request: request))
    }
    
    func saveAllergies(profileId: String, request: AllergyRequestDTO) async throws {
        try await networkClient.requestWithoutResponse(ProfileEndpoint.saveAllergies(profileId: profileId, request: request))
    }
    
    func saveMedications(profileId: String, request: MedicationRequestDTO) async throws {
        try await networkClient.requestWithoutResponse(ProfileEndpoint.saveMedications(profileId: profileId, request: request))
    }

    func saveMedicalHistory(profileId: String, request: MedicalHistoryRequestDTO) async throws {
        try await networkClient.requestWithoutResponse(ProfileEndpoint.saveMedicalHistory(profileId: profileId, request: request))
    }
 

    func saveEmergencyContact(profileId: String, request: EmergencyContactRequestDTO) async throws {
        try await networkClient.requestWithoutResponse(ProfileEndpoint.saveEmergencyContact(profileId: profileId, request: request))
    }

    func saveAddress(profileId: String, request: AddressRequestDTO) async throws {
        try await networkClient.requestWithoutResponse(ProfileEndpoint.saveAddress(profileId: profileId, request: request))
    }
}
