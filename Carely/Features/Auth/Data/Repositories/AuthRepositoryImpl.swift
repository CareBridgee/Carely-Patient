//
//  RepositoryImpl.swift
//  Carely
//
//  Created by Mona Zarea on 15/07/2026.
//

import Foundation

final class AuthRepositoryImpl: AuthRepositoryProtocol {
    private let authService: AuthServiceProtocol

    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }

    func login(phoneNumber: String) async throws {
        try await authService.login(phoneNumber: phoneNumber)
    }

    func resendOTP(phoneNumber: String) async throws {
        try await authService.login(phoneNumber: phoneNumber)
    }

    func requestOTPDev(phoneNumber: String) async throws -> DevOTPResponse {
        try await authService.requestOTPDev(phoneNumber: phoneNumber)
    }

    func verifyOTP(phoneNumber: String, otp: String) async throws -> OTPVerificationEntity {
        let response = try await authService.verifyOTP(phoneNumber: phoneNumber, otp: otp)

        return OTPVerificationEntity(
            isNewUser: response.user.firstName == "User" || response.user.lastName?.isEmpty == true,
            accessToken: response.accessToken,
            refreshToken: response.refreshToken,
            userId: response.user.id
        )
    }

    func getProfile(phoneNumber: String) async throws -> UserDTO {
        try await authService.getProfile(phoneNumber: phoneNumber)
    }

    func logout(refreshToken: String) async throws {
        do {
            try await authService.logout(refreshToken: refreshToken)
        } catch {
            print("Failed to logout on server: \(error)")
        }
    }

    func savePersonalInfo(basicInfo: BasicUserInfo) async throws {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]
        let dobString = formatter.string(from: basicInfo.dateOfBirth)

        try await authService.savePersonalInfo(
            firstName: basicInfo.firstName,
            lastName: basicInfo.secondName,
            dateOfBirth: dobString,
            gender: basicInfo.Gender.rawValue,
            profileImage: basicInfo.profileImage
        )
    }
    }

