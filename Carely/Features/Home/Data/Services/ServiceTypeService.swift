//
//  ServiceTypeService.swift
//  Carely
//
//  Created by Mina on 28/07/2026.
//

import Foundation

protocol ServiceTypeServiceProtocol {
    func getServiceTypes() async throws -> [ServiceTypeDTO]
    func getServiceType(id: String) async throws -> ServiceTypeDTO
}

final class ServiceTypeServiceImpl: ServiceTypeServiceProtocol {
    private let networkClient: NetworkClientProtocol
    var useLogs: Bool = false

    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }

    func getServiceTypes() async throws -> [ServiceTypeDTO] {
        if useLogs { print("ServiceTypeService: fetching service types") }
        return try await networkClient.request(ServiceTypeEndpoint.getServiceTypes)
    }

    func getServiceType(id: String) async throws -> ServiceTypeDTO {
        if useLogs { print("ServiceTypeService: fetching service type \(id)") }
        return try await networkClient.request(ServiceTypeEndpoint.getServiceType(id: id))
    }
}
