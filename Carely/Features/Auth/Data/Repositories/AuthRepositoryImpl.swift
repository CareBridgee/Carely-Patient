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

    func verifyOTP(phoneNumber: String, otp: String, pendingToken: String? = nil) async throws -> OTPVerificationEntity {
            let response = try await authService.verifyOTP(phoneNumber: phoneNumber, otp: otp, pendingToken: pendingToken)
            
            let user = User(
                id: response.user.id,
                phoneNumber: response.user.phoneNumber,
                email: response.user.email,
                firstName: response.user.firstName,
                lastName: response.user.lastName,
                dateOfBirth: response.user.dateOfBirth,
                gender: response.user.gender?.rawValue, 
                profileImageUrl: response.user.profileImageUrl,
                isDeleted: response.user.isDeleted,
                createdAt: response.user.createdAt,
                updatedAt: response.user.updatedAt,
                lastLoginAt: response.user.lastLoginAt,
                defaultProfileId: response.user.defaultProfileId
            )

            return OTPVerificationEntity(
                isNewUser: response.user.firstName == "User" || response.user.lastName?.isEmpty == true,
                accessToken: response.accessToken,
                refreshToken: response.refreshToken,
                userId: response.user.id,
                user: user
            )
        }

        func googleLogin(idToken: String) async throws -> GoogleAuthResponse {
            return try await authService.googleLogin(idToken: idToken)
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

    func savePersonalInfo(basicInfo: BasicUserInfo, defaultProfileId: String?) async throws -> String? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]
        let dobString = formatter.string(from: basicInfo.dateOfBirth)

        // Return the result from the service
        return try await authService.savePersonalInfo(
            firstName: basicInfo.firstName,
            lastName: basicInfo.secondName,
            dateOfBirth: dobString,
            gender: basicInfo.Gender.rawValue,
            profileImage: basicInfo.profileImage,
            defaultProfileId: defaultProfileId
        )
    }
    }
    

