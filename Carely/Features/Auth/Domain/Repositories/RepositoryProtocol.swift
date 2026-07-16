//
//  file.swift
//  Carely
//
//  Created by Mona Zarea on 15/07/2026.
//

import Foundation
protocol AuthRepositoryProtocol {
    func verifyOTP(phoneNumber: String, otp: String) async throws -> OTPVerificationEntity
}
