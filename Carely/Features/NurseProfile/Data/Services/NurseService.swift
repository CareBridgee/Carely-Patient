//
//  NurseService.swift
//  Carely
//
//  Created by Mina on 08/08/2026.
//

import Foundation

protocol NurseServiceProtocol {
    func getNurse(id: String) async throws -> NurseDTO
}

final class NurseServiceImpl: NurseServiceProtocol {
    private let networkClient: NetworkClientProtocol
    let useLogs: Bool = false

    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }

    func getNurse(id: String) async throws -> NurseDTO {
        if useLogs { print("NurseService: fetching nurse \(id)") }
        return try await networkClient.request(NurseEndpoint.getNurse(id: id))
    }
}
