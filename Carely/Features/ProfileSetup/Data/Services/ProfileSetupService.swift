//
//  ProfileSetupService.swift
//  Carely
//

import Foundation
import Alamofire

final class ProfileSetupService: ProfileSetupServiceProtocol {
    
    private let networkClient: NetworkClientProtocol

    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }

    private struct DefaultProfileResponse: Decodable {
        let id: String
    }

    func fetchDefaultProfileId() async throws -> String {
        let response: DefaultProfileResponse = try await networkClient.request(ProfileEndpoint.getDefaultProfile)
        return response.id
    }

    func updateBasicInfo(profileId: String, height: Double?, weight: Double?, bloodType: String) async throws {
        var params: [String: Any] = ["bloodType": bloodType]
        if let height = height { params["height"] = height }
        if let weight = weight { params["weight"] = weight }
        
        try await networkClient.requestWithoutResponse(
            ProfileEndpoint.updateBasicInfo(id: profileId, parameters: params)
        )
    }

    func saveMedicalHistory(profileId: String, surgeries: String, hospitalizations: String) async throws {
        let params: [String: Any] = [
            "previousSurgeries": surgeries,
            "previousHospitalizations": hospitalizations
        ]
        try await networkClient.requestWithoutResponse(
            ProfileEndpoint.saveMedicalHistory(profileId: profileId, parameters: params)
        )
    }

    func saveEmergencyContact(profileId: String, name: String, phone: String, relationship: String) async throws {
        let params: [String: Any] = [
            "firstName": name, 
            "phoneNumber": phone,
            "relationship": relationship
        ]
        try await networkClient.requestWithoutResponse(
            ProfileEndpoint.saveEmergencyContact(profileId: profileId, parameters: params)
        )
    }

    func saveAddress(profileId: String, address: HomeAddress) async throws {
        let params: [String: Any] = [
            "country": address.country,
            "city": address.city,
            "area": address.area,
            "street": address.streetName,
            "buildingNumber": address.building,
            "apartmentNumber": address.apartment,
            "latitude": address.latitude ?? 0.0,
            "longitude": address.longitude ?? 0.0
        ]
        try await networkClient.requestWithoutResponse(
            ProfileEndpoint.saveAddress(profileId: profileId, parameters: params)
        )
    }
}