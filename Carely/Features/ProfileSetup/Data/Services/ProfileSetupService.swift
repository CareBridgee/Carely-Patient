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
    func getAllMedicalConditions() async throws -> [SystemMedicalConditionDTO]
    func getProfileMedicalConditions(profileId: String) async throws -> [ProfileMedicalConditionDTO]
    func addMedicalCondition(profileId: String, request: AddMedicalConditionRequestDTO) async throws
    func removeMedicalCondition(profileId: String, medicalConditionId: String) async throws
    func getAllAllergies() async throws -> [SystemAllergyDTO]
    func getProfileAllergies(profileId: String) async throws -> [ProfileAllergyDTO]
    func addAllergy(profileId: String, request: AddAllergyRequestDTO) async throws
    func removeAllergy(profileId: String, allergyId: String) async throws
    func getProfileMedications(profileId: String) async throws -> [ProfileMedicationDTO]
    func addMedication(profileId: String, request: AddMedicationRequestDTO) async throws -> ProfileMedicationDTO
    func removeMedication(profileId: String, medicationId: String) async throws
    func saveMedicalHistory(profileId: String, request: MedicalHistoryRequestDTO) async throws
    func getEmergencyContacts(profileId: String) async throws -> [EmergencyContactResponseDTO]
    func saveEmergencyContact(profileId: String, request: EmergencyContactRequestDTO) async throws
    func updateEmergencyContact(contactId: String, request: EmergencyContactRequestDTO) async throws
    func saveAddress(profileId: String, request: AddressRequestDTO) async throws
    func createProfile(request: CreateProfileRequestDTO) async throws -> String
    func updateAddress(profileId: String, request: AddressRequestDTO) async throws
    func fetchAddress(profileId: String) async throws -> AddressResponseDTO?
}

final class ProfileSetupServiceImpl: ProfileSetupServiceProtocol {
    private let networkClient: NetworkClientProtocol
    init(networkClient: NetworkClientProtocol) { self.networkClient = networkClient }

    private struct DefaultProfileResponse: Decodable { let id: String }

    func fetchDefaultProfileId() async throws -> String {
        let response: DefaultProfileResponse = try await networkClient.request(ProfileEndpoint.getDefaultProfile)
        return response.id
    }

    func getAllMedicalConditions() async throws -> [SystemMedicalConditionDTO] {
        try await networkClient.request(ProfileEndpoint.getAllMedicalConditions)
    }

    func getProfileMedicalConditions(profileId: String) async throws -> [ProfileMedicalConditionDTO] {
        do {
            return try await networkClient.request(ProfileEndpoint.getProfileMedicalConditions(profileId: profileId))
        } catch {
            return []
        }
    }

    func addMedicalCondition(profileId: String, request: AddMedicalConditionRequestDTO) async throws {
        try await networkClient.requestWithoutResponse(ProfileEndpoint.addMedicalCondition(profileId: profileId, request: request))
    }

    func removeMedicalCondition(profileId: String, medicalConditionId: String) async throws {
        try await networkClient.requestWithoutResponse(ProfileEndpoint.removeMedicalCondition(profileId: profileId, medicalConditionId: medicalConditionId))
    }

    func getAllAllergies() async throws -> [SystemAllergyDTO] {
        try await networkClient.request(ProfileEndpoint.getAllAllergies)
    }

    func getProfileAllergies(profileId: String) async throws -> [ProfileAllergyDTO] {
        do {
            return try await networkClient.request(ProfileEndpoint.getProfileAllergies(profileId: profileId))
        } catch {
            return []
        }
    }

    func addAllergy(profileId: String, request: AddAllergyRequestDTO) async throws {
        try await networkClient.requestWithoutResponse(ProfileEndpoint.addAllergy(profileId: profileId, request: request))
    }

    func removeAllergy(profileId: String, allergyId: String) async throws {
        try await networkClient.requestWithoutResponse(ProfileEndpoint.removeAllergy(profileId: profileId, allergyId: allergyId))
    }

    func getProfileMedications(profileId: String) async throws -> [ProfileMedicationDTO] {
        do {
            return try await networkClient.request(ProfileEndpoint.getProfileMedications(profileId: profileId))
        } catch {
            return []
        }
    }

    func addMedication(profileId: String, request: AddMedicationRequestDTO) async throws -> ProfileMedicationDTO {
        try await networkClient.request(ProfileEndpoint.addMedication(profileId: profileId, request: request))
    }

    func removeMedication(profileId: String, medicationId: String) async throws {
        try await networkClient.requestWithoutResponse(ProfileEndpoint.removeMedication(profileId: profileId, medicationId: medicationId))
    }

    func fetchAddress(profileId: String) async throws -> AddressResponseDTO? {
        do {
            return try await networkClient.request(ProfileEndpoint.getAddress(profileId: profileId))
        } catch let error as NetworkError {
            if case .server(404, _) = error { return nil }
            throw error
        }
    }

    func updateProfile(id: String, request: UpdateProfileRequestDTO) async throws {
        // PUT /api/v1/profiles/{id} is multipart/form-data only (per API contract) — JSON reaches
        // the server with nothing parsed.
        var textParameters: [String: String] = [:]
        if let height = request.height { textParameters["height"] = String(height) }
        if let weight = request.weight { textParameters["weight"] = String(weight) }
        if let bloodType = request.bloodType { textParameters["bloodType"] = bloodType }
        if let mobilityStatus = request.mobilityStatus { textParameters["mobilityStatus"] = mobilityStatus }
        if let mobilityNotes = request.mobilityNotes { textParameters["mobilityNotes"] = mobilityNotes }
        if let previousSurgeries = request.previousSurgeries { textParameters["previousSurgeries"] = previousSurgeries }
        if let previousHospitalizations = request.previousHospitalizations { textParameters["previousHospitalizations"] = previousHospitalizations }

        try await networkClient.requestMultipartWithoutResponse(
            ProfileEndpoint.updateProfile(id: id, request: request),
            textParameters: textParameters
        )
    }
    

    func saveMedicalHistory(profileId: String, request: MedicalHistoryRequestDTO) async throws {
        try await networkClient.requestWithoutResponse(ProfileEndpoint.saveMedicalHistory(profileId: profileId, request: request))
    }
 

    func getEmergencyContacts(profileId: String) async throws -> [EmergencyContactResponseDTO] {
        do {
            return try await networkClient.request(ProfileEndpoint.getEmergencyContacts(profileId: profileId))
        } catch {
            return []
        }
    }

    func saveEmergencyContact(profileId: String, request: EmergencyContactRequestDTO) async throws {
        try await networkClient.requestWithoutResponse(ProfileEndpoint.saveEmergencyContact(profileId: profileId, request: request))
    }

    func updateEmergencyContact(contactId: String, request: EmergencyContactRequestDTO) async throws {
        try await networkClient.requestWithoutResponse(ProfileEndpoint.updateEmergencyContact(contactId: contactId, request: request))
    }

    func saveAddress(profileId: String, request: AddressRequestDTO) async throws {
        try await networkClient.requestWithoutResponse(ProfileEndpoint.saveAddress(profileId: profileId, request: request))
    }
    func createProfile(request: CreateProfileRequestDTO) async throws -> String {
           // POST /api/v1/profiles is multipart/form-data only (per API contract) — JSON reaches
           // the server with nothing parsed.
           let response: CreateProfileResponseDTO = try await networkClient.requestMultipart(
               ProfileEndpoint.createProfile(request: request),
               textParameters: [
                   "relationship": request.relationship,
                   "firstName": request.firstName,
                   "lastName": request.lastName,
                   "dateOfBirth": request.dateOfBirth,
                   "gender": request.gender
               ]
           )
           return response.id
       }
    func updateAddress(profileId: String, request: AddressRequestDTO) async throws {
           try await networkClient.requestWithoutResponse(
               ProfileEndpoint.updateAddress(profileId: profileId, request: request)
           )
        }
}
