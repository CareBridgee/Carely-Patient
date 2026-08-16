//
//  ServiceRequestServiceProtocol.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 01/08/2026.
//


import Foundation

struct VisitCodeResponseDTO: Decodable {
    let serviceRequestId: String
    let code: String
    let expiresAt: String?
}

protocol ServiceRequestServiceProtocol {
    func getProfiles() async throws -> [ProfileResponseDTO]
    func getAddress(profileId: String) async throws -> AddressResponseDTO
    func submitServiceRequest(_ body: ServiceRequestBodyDTO) async throws -> ServiceRequestResponseDTO
    func acceptOffer(offerId: String) async throws
    func declineOffer(offerId: String) async throws
    func cancelServiceRequest(serviceRequestId: String) async throws
    func fetchVisitCode(serviceRequestId: String) async throws -> VisitCodeResponseDTO
}

final class ServiceRequestServiceImpl: ServiceRequestServiceProtocol {
    private let networkClient: NetworkClientProtocol
    let useLogs: Bool = true

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

struct EmptyResponse: Decodable {}

    func acceptOffer(offerId: String) async throws {
        if useLogs { print("ServiceRequestService: acceptOffer \(offerId)") }
        let endpoint = ServiceRequestEndpoint.acceptOffer(offerId: offerId)
        _ = try await networkClient.request(endpoint) as EmptyResponse
    }

    func declineOffer(offerId: String) async throws {
        if useLogs { print("ServiceRequestService: declineOffer \(offerId)") }
        let endpoint = ServiceRequestEndpoint.declineOffer(offerId: offerId)
        _ = try await networkClient.request(endpoint) as EmptyResponse
    }

    func cancelServiceRequest(serviceRequestId: String) async throws {
        if useLogs { print("ServiceRequestService: cancelServiceRequest \(serviceRequestId)") }
        let endpoint = ServiceRequestEndpoint.cancelServiceRequest(serviceRequestId: serviceRequestId)
        _ = try await networkClient.request(endpoint) as EmptyResponse
    }

    func fetchVisitCode(serviceRequestId: String) async throws -> VisitCodeResponseDTO {
        if useLogs { print("ServiceRequestService: fetchVisitCode \(serviceRequestId)") }
        let endpoint = ServiceRequestEndpoint.fetchVisitCode(serviceRequestId: serviceRequestId)
        return try await networkClient.request(endpoint)
    }
}
