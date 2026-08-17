//
//  WalletServiceProtocol.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 16/08/2026.
//


import Foundation

protocol WalletServiceProtocol {
    func getCurrentUserId() async throws -> String
    func getCredit(userId: String) async throws -> Double
    func updateCredit(userId: String, amount: Double, operation: String) async throws -> Double
}

final class WalletServiceImpl: WalletServiceProtocol {
    private let networkClient: NetworkClientProtocol
    
    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }
    
    func getCurrentUserId() async throws -> String {
        let response: WalletCurrentUserDTO = try await networkClient.request(WalletEndpoint.currentUser)
        return response.id
    }
    
    func getCredit(userId: String) async throws -> Double {
        let response: WalletCreditResponseDTO = try await networkClient.request(WalletEndpoint.getCredit(userId: userId))
        return response.credit
    }
    
    func updateCredit(userId: String, amount: Double, operation: String) async throws -> Double {
        let response: WalletCreditUpdateResponseDTO = try await networkClient.request(
            WalletEndpoint.updateCredit(userId: userId, amount: amount, operation: operation)
        )
        return response.credit
    }
}