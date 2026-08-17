//
//  GetWalletSummaryUseCaseProtocol.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 16/08/2026.
//


import Foundation

protocol GetWalletSummaryUseCaseProtocol {
    func execute() async throws -> WalletSummary
}

final class GetWalletSummaryUseCase: GetWalletSummaryUseCaseProtocol {
    private let repository: WalletRepositoryProtocol
    init(repository: WalletRepositoryProtocol) { self.repository = repository }

    func execute() async throws -> WalletSummary {
        try await repository.fetchWalletSummary()
    }
}

// MARK: - Add Wallet Credit (unchanged)

protocol AddWalletCreditUseCaseProtocol {
    func execute(userId: String, amount: Double) async throws -> Double
}

final class AddWalletCreditUseCase: AddWalletCreditUseCaseProtocol {
    private let repository: WalletRepositoryProtocol
    init(repository: WalletRepositoryProtocol) { self.repository = repository }

    func execute(userId: String, amount: Double) async throws -> Double {
        guard amount > 0 else { throw WalletError.invalidAmount }
        return try await repository.updateWalletCredit(userId: userId, amount: amount, operation: .add)
    }
}