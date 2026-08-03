//
//  ServiceRequestServiceProtocol.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 01/08/2026.
//


import Foundation

protocol ServiceRequestServiceProtocol {
    func getProfiles() async throws -> [ProfileResponseDTO]
    func getAddress(profileId: String) async throws -> AddressResponseDTO
    func submitServiceRequest(_ body: ServiceRequestBodyDTO) async throws -> ServiceRequestResponseDTO
}

final class ServiceRequestServiceImpl: ServiceRequestServiceProtocol {
    private let networkClient: NetworkClientProtocol
    var useLogs: Bool = false

    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }

    func getProfiles() async throws -> [ProfileResponseDTO] {
        if useLogs { print("ServiceRequestService: getProfiles") }
        return try await networkClient.request(ServiceRequestEndpoint.getProfiles)
    }

    func getAddress(profileId: String) async throws -> AddressResponseDTO {
        if useLogs { print("ServiceRequestService: getAddress \(profileId)") }
        return try await networkClient.request(ServiceRequestEndpoint.getAddress(profileId: profileId))
    }

    func submitServiceRequest(_ body: ServiceRequestBodyDTO) async throws -> ServiceRequestResponseDTO {
        if useLogs { print("ServiceRequestService: submitServiceRequest \(body.profileId)") }
        return try await networkClient.request(ServiceRequestEndpoint.submitServiceRequest(body))
    }
}