//
//  so.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 16/07/2026.
//


import Foundation
protocol VerifyOTPUseCaseProtocol {
    func execute(phoneNumber: String, otp: String) async throws -> OTPVerificationEntity
}

struct VerifyOTPUseCase: VerifyOTPUseCaseProtocol {
    private let repository: AuthRepositoryProtocol
    private let tokenStore: TokenStoring
    private let sessionManager: SessionManager

    init(
        repository: AuthRepositoryProtocol,
        tokenStore: TokenStoring,
        sessionManager: SessionManager
    ) {
        self.repository = repository
        self.tokenStore = tokenStore
        self.sessionManager = sessionManager
    }

    func execute(phoneNumber: String, otp: String) async throws -> OTPVerificationEntity {
        guard otp.count == 6, otp.allSatisfy(\.isNumber) else {
            throw AuthError.invalidOTP
        }
        let entity = try await repository.verifyOTP(phoneNumber: phoneNumber, otp: otp)

        tokenStore.saveTokens(access: entity.accessToken, refresh: entity.refreshToken ?? "")

        await MainActor.run {
            sessionManager.setLoggedIn()
        }

        return entity
    }
}
