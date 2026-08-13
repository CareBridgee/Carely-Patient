//
//  AuthService.swift
//  Carely
//

import Foundation
import UIKit

protocol AuthServiceProtocol {
    func login(phoneNumber: String) async throws
    func requestOTPDev(phoneNumber: String) async throws -> DevOTPResponse
    func verifyOTP(phoneNumber: String, otp: String) async throws -> AuthResponse
    func getProfile(phoneNumber: String) async throws -> UserDTO
    func refresh(refreshToken: String) async throws -> AuthResponse
    func logout(refreshToken: String) async throws
    func savePersonalInfo(
        firstName: String, lastName: String, dateOfBirth: String, gender: String,
        profileImage: UIImage?, defaultProfileId: String?
    ) async throws -> String?
}
final class AuthServiceImpl: AuthServiceProtocol {
    private let networkClient: NetworkClientProtocol
    private let cloudinaryService: CloudinaryUploadServiceProtocol

    var useLogs: Bool = true

    init(networkClient: NetworkClientProtocol,cloudinaryService: CloudinaryUploadServiceProtocol
) {
        self.networkClient = networkClient
        self.cloudinaryService = cloudinaryService

    }

    func login(phoneNumber: String) async throws {
        if useLogs { print("AuthService: login with phoneNumber: \(phoneNumber)") }
        try await networkClient.requestWithoutResponse(
            AuthEndpoint.login(phoneNumber: phoneNumber)
        )
    }

    func requestOTPDev(phoneNumber: String) async throws -> DevOTPResponse {
        if useLogs { print("AuthService: requestOTPDev with phoneNumber: \(phoneNumber)") }
        return try await networkClient.request(
            AuthEndpoint.requestOTPDev(phoneNumber: phoneNumber)
        )
    }

    func verifyOTP(phoneNumber: String, otp: String) async throws -> AuthResponse {
        if useLogs { print("AuthService: verifyOTP with phoneNumber: \(phoneNumber), otp: \(otp)") }
        return try await networkClient.request(
            AuthEndpoint.verifyOTP(phoneNumber: phoneNumber, otp: otp)
        )
    }

    func getProfile(phoneNumber: String) async throws -> UserDTO {
        if useLogs { print("AuthService: getProfile with phoneNumber: \(phoneNumber)") }
        return try await networkClient.request(
            AuthEndpoint.profile(phoneNumber: phoneNumber)
        )
    }

    func refresh(refreshToken: String) async throws -> AuthResponse {
        if useLogs { print("AuthService: refresh with refreshToken: \(refreshToken)") }
        return try await networkClient.request(
            AuthEndpoint.refresh(refreshToken: refreshToken)
        )
    }

    func logout(refreshToken: String) async throws {
        if useLogs { print("AuthService: logout with refreshToken: \(refreshToken)") }
        try await networkClient.requestWithoutResponse(
            AuthEndpoint.logout(refreshToken: refreshToken)
        )
    }
    func savePersonalInfo(
        firstName: String, lastName: String, dateOfBirth: String, gender: String,
        profileImage: UIImage?, defaultProfileId: String?
    ) async throws -> String? {

        var uploadedImageUrl: String?
        if let profileImage {
            let result = try await cloudinaryService.uploadImage(profileImage, compressionQuality: 0.5)
            uploadedImageUrl = result.secureUrl
        }

        let userRequest = UserUpdateRequestDTO(
            firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth,
            gender: gender, profileImageUrl: uploadedImageUrl
        )

        // PUT /api/v1/users/me is documented (Swagger) as multipart/form-data only — it does not
        // consume a JSON body. Sending it as JSON (the old `requestWithoutResponse` path, which
        // defaults to JSONEncoding for PUT) silently reaches the server with no parsed fields.
        var textParameters: [String: String] = [
            "firstName": userRequest.firstName,
            "lastName": userRequest.lastName,
            "dateOfBirth": userRequest.dateOfBirth,
            "gender": userRequest.gender
        ]
        if let profileImageUrl = userRequest.profileImageUrl {
            textParameters["profileImageUrl"] = profileImageUrl
        }

        try await networkClient.requestMultipartWithoutResponse(
            AuthEndpoint.updateUser(request: userRequest),
            textParameters: textParameters
        )

        if let profileId = defaultProfileId {
            let profileRequest = PersonalInfoRequestDTO(
                relationship: "SELF", firstName: firstName, lastName: lastName,
                dateOfBirth: dateOfBirth, gender: gender
            )
            // PUT /api/v1/profiles/{id} is also documented as multipart/form-data only (confirmed via
            // Swagger) — same issue as /users/me. Sending it as JSON reaches the server with nothing
            // parsed, which is what was causing the 500 here.
            try await networkClient.requestMultipartWithoutResponse(
                AuthEndpoint.updateProfile(id: profileId, request: profileRequest),
                textParameters: [
                    "relationship": profileRequest.relationship,
                    "firstName": profileRequest.firstName,
                    "lastName": profileRequest.lastName,
                    "dateOfBirth": profileRequest.dateOfBirth,
                    "gender": profileRequest.gender
                ]
            )
        }
        
        return uploadedImageUrl
    }
    }
