//
//  file.swift
//  Carely
//
//  Created by Mona Zarea on 15/07/2026.
//

import Foundation

protocol AuthRepositoryProtocol {
    func login(phoneNumber: String) async throws
    func resendOTP(phoneNumber: String) async throws
    func requestOTPDev(phoneNumber: String) async throws -> DevOTPResponse
    func verifyOTP(phoneNumber: String, otp: String) async throws -> OTPVerificationEntity
    func getProfile(phoneNumber: String) async throws -> UserDTO
    func logout(refreshToken: String) async throws
    func savePersonalInfo(
        basicInfo: BasicUserInfo
        ) async throws
}
