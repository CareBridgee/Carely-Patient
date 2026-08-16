//
//  GetCurrentUserIdUseCaseProtocol.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 16/08/2026.
//


import Foundation

// MARK: - Get Current User Id


// MARK: - Create Paymob Intention

protocol GetPaymobCheckoutURLUseCaseProtocol {
    func execute(amount: Double) async throws -> URL
}

final class GetPaymobCheckoutURLUseCase: GetPaymobCheckoutURLUseCaseProtocol {
    private let repository: WalletRepositoryProtocol
    init(repository: WalletRepositoryProtocol) { self.repository = repository }

    func execute(amount: Double) async throws -> URL {
        guard amount > 0 else { throw WalletError.invalidAmount }
        return try await repository.createPaymobCheckoutURL(amount: amount)
    }
}
