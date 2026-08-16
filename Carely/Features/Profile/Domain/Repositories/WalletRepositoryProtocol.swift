//
//  WalletRepositoryProtocol.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 16/08/2026.
//


import Foundation

struct WalletSummary {
    let userId: String
    let balance: Double
}

protocol WalletRepositoryProtocol {
    /// REAL — GET /api/v1/users/me. No more fake balance call; credit comes
    /// straight from this response now that the DTO decodes it.
    func fetchWalletSummary() async throws -> WalletSummary

    /// REAL — PATCH /api/v1/users/{userId}/credit.
    func updateWalletCredit(userId: String, amount: Double, operation: WalletCreditOperation) async throws -> Double

    /// REAL — direct client-side Paymob integration (auth -> order -> payment_key).
    func createPaymobCheckoutURL(amount: Double) async throws -> URL
}
