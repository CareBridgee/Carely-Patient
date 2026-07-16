//
//  RepositoryImpl.swift
//  Carely
//
//  Created by Mona Zarea on 15/07/2026.
//

import Foundation
final class AuthRepositoryImpl: AuthRepositoryProtocol {
    
    private static let mockCorrectOTP = "1234"
    
    private let simulatedDelayNanoseconds: UInt64 = 1_200_000_000
    
    func verifyOTP(phoneNumber: String, otp: String) async throws -> OTPVerificationEntity {
        // Simulate network delay.
        try await Task.sleep(nanoseconds: simulatedDelayNanoseconds)
        
        guard otp == Self.mockCorrectOTP else {
            throw AuthError.invalidOTP
        }
        
        
        return OTPVerificationEntity(isNewUser: true, accessToken: "", refreshToken: "", userId: "")
    }
}
