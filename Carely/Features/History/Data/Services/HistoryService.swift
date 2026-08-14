//
//  HistoryService.swift
//  Carely
//
//  Created by Mina on 14/08/2026.
//

import Foundation
 
protocol HistoryServiceProtocol {
    func getConfirmedRequests() async throws -> [ServiceRequestHistoryDTO]
    func getRequestDetail(id: String) async throws -> ServiceRequestDetailDTO
}
 
final class HistoryServiceImpl: HistoryServiceProtocol {
    private let networkClient: NetworkClientProtocol
    let useLogs: Bool = true
 
    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }
 
    func getConfirmedRequests() async throws -> [ServiceRequestHistoryDTO] {
        if useLogs { print("HistoryService: getConfirmedRequests") }
        return try await networkClient.request(HistoryEndpoint.getConfirmedRequests)
    }
 
    func getRequestDetail(id: String) async throws -> ServiceRequestDetailDTO {
        if useLogs { print("HistoryService: getRequestDetail \(id)") }
        return try await networkClient.request(HistoryEndpoint.getRequestDetail(id: id))
    }
}
 
