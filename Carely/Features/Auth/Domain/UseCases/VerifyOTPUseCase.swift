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

    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    func execute(phoneNumber: String, otp: String) async throws -> OTPVerificationEntity {
        guard otp.count == 4, otp.allSatisfy(\.isNumber) else {
            throw AuthError.invalidOTP
        }
        return try await repository.verifyOTP(phoneNumber: phoneNumber, otp: otp)
    }
}
