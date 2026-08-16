//
//  WalletNetworkClientProtocol.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 16/08/2026.
//


//
//  WalletAPIService.swift
//  Carely
//

protocol WalletAPIServiceProtocol {
    func fetchCurrentUser() async throws -> WalletCurrentUserDTO
    func fetchCredit(userId: String) async throws -> WalletCreditResponseDTO
    func updateCredit(userId: String, amount: Double, operation: WalletCreditOperation) async throws -> WalletCreditUpdateResponseDTO
}

final class WalletAPIService: WalletAPIServiceProtocol {
    private let networkClient: NetworkClientProtocol

    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }

    func fetchCurrentUser() async throws -> WalletCurrentUserDTO {
        try await networkClient.request(WalletEndpoint.currentUser)
    }

    func fetchCredit(userId: String) async throws -> WalletCreditResponseDTO {
        try await networkClient.request(WalletEndpoint.getCredit(userId: userId))
    }

    func updateCredit(userId: String, amount: Double, operation: WalletCreditOperation) async throws -> WalletCreditUpdateResponseDTO {
        try await networkClient.request(
            WalletEndpoint.updateCredit(userId: userId, amount: amount, operation: operation.rawValue)
        )
    }
}
