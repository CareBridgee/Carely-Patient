//
//  WalletRepositoryImpl.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 16/08/2026.
//


import Foundation

final class WalletRepositoryImpl: WalletRepositoryProtocol {
    private let apiService: WalletAPIServiceProtocol
    private let paymobDirectService: PaymobDirectAPIServiceProtocol

    init(apiService: WalletAPIServiceProtocol, paymobDirectService: PaymobDirectAPIServiceProtocol) {
        self.apiService = apiService
        self.paymobDirectService = paymobDirectService
    }

    func fetchWalletSummary() async throws -> WalletSummary {
        let userDto = try await apiService.fetchCurrentUser()
        let creditDto = try await apiService.fetchCredit(userId: userDto.id)
        return WalletSummary(userId: userDto.id, balance: creditDto.credit)
    }

    func updateWalletCredit(userId: String, amount: Double, operation: WalletCreditOperation) async throws -> Double {
        do {
            let response = try await apiService.updateCredit(userId: userId, amount: amount, operation: operation)
            return response.credit
        } catch {
            throw mapInsufficientCreditIfNeeded(error)
        }
    }

    func createPaymobCheckoutURL(amount: Double) async throws -> URL {
        try await paymobDirectService.createCheckoutURL(
            amount: amount,
            billing: PaymobBillingData(),
            merchantOrderId: Int(Date().timeIntervalSince1970)
        )
    }

    private func mapInsufficientCreditIfNeeded(_ error: Error) -> Error {
        return error
    }
}
