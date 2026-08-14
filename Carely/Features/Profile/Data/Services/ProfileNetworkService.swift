//
//  ProfileNetworkService.swift
//  Carely
//

import Alamofire
import Foundation
import UIKit

// MARK: - Response DTO

struct FullProfileResponseDTO: Decodable {
    let id: String
    let userId: String?
    let relationship: String?
    let firstName: String?
    let lastName: String?
    let dateOfBirth: String?
    let gender: String?
    let bloodType: String?
    let height: Double?
    let weight: Double?
    let mobilityStatus: String?
    let mobilityNotes: String?
    let previousSurgeries: String?
    let previousHospitalizations: String?
    let profileImageUrl: String?
    let isPrimary: Bool?
    let isDeleted: Bool?
}

// MARK: - Request Params (multipart fields)

struct ProfileUpdateRequestParams {
    var firstName: String
    var lastName: String
    var dateOfBirth: String
    var gender: String
    var relationship: String
    var bloodType: String?
    var height: Double?
    var weight: Double?
    var mobilityStatus: String?
    var mobilityNotes: String?
    var previousSurgeries: String?
    var previousHospitalizations: String?
    var profileImageUrl: String?

    /// Builds the multipart text dictionary for PUT /api/v1/profiles/{id}.
    func asProfileTextParameters() -> [String: String] {
        var p: [String: String] = [:]
        if !firstName.isEmpty    { p["firstName"]    = firstName }
        if !lastName.isEmpty     { p["lastName"]     = lastName }
        if !dateOfBirth.isEmpty  { p["dateOfBirth"]  = dateOfBirth }
        if !gender.isEmpty       { p["gender"]       = gender }
        if !relationship.isEmpty { p["relationship"] = relationship }
        if let bt = bloodType                { p["bloodType"]                = bt }
        if let h  = height                   { p["height"]                   = String(h) }
        if let w  = weight                   { p["weight"]                   = String(w) }
        if let ms = mobilityStatus           { p["mobilityStatus"]           = ms }
        if let mn = mobilityNotes            { p["mobilityNotes"]            = mn }
        if let ps = previousSurgeries        { p["previousSurgeries"]        = ps }
        if let ph = previousHospitalizations { p["previousHospitalizations"] = ph }
        if let pu = profileImageUrl          { p["profileImageUrl"]          = pu }
        return p
    }

    /// Builds the multipart text dictionary for PUT /api/v1/users/me.
    func asUserTextParameters() -> [String: String] {
        var p: [String: String] = [
            "firstName": firstName,
            "lastName": lastName,
            "dateOfBirth": dateOfBirth,
            "gender": gender
        ]
        if let pu = profileImageUrl { p["profileImageUrl"] = pu }
        return p
    }
}

// MARK: - Protocol

protocol ProfileNetworkServiceProtocol {
    /// GET /api/v1/profiles — all profiles for the logged-in user.
    func fetchAllProfiles() async throws -> [FullProfileResponseDTO]
    /// GET /api/v1/profiles/default
    func fetchDefaultProfile() async throws -> FullProfileResponseDTO
    /// PUT /api/v1/profiles/{id}  — also calls PUT /api/v1/users/me when id is the primary profile.
    func updateProfile(id: String, params: ProfileUpdateRequestParams, image: UIImage?) async throws
    /// POST /api/v1/profiles
    func createProfile(params: ProfileUpdateRequestParams, image: UIImage?) async throws -> FullProfileResponseDTO
    /// DELETE /api/v1/profiles/{id}
    func deleteProfile(id: String) async throws
}

// MARK: - Private endpoint enums

private enum ProfileFetchEndpoint: Endpoint {
    case allProfiles
    case defaultProfile

    var path: String {
        switch self {
        case .allProfiles:    return "/api/v1/profiles"
        case .defaultProfile: return "/api/v1/profiles/default"
        }
    }
    var method: HTTPMethod { .get }
}

private enum ProfileMutateEndpoint: Endpoint {
    case updateProfile(id: String)
    case createProfile
    case updateUser
    case deleteProfile(id: String)

    var path: String {
        switch self {
        case .updateProfile(let id): return "/api/v1/profiles/\(id)"
        case .createProfile:         return "/api/v1/profiles"
        case .updateUser:            return "/api/v1/users/me"
        case .deleteProfile(let id): return "/api/v1/profiles/\(id)"
        }
    }
    var method: HTTPMethod {
        switch self {
        case .updateProfile, .updateUser: return .put
        case .createProfile:              return .post
        case .deleteProfile:              return .delete
        }
    }
}

// MARK: - Implementation

final class ProfileNetworkService: ProfileNetworkServiceProtocol {

    private let networkClient: NetworkClientProtocol
    private let sessionManager: SessionManager

    init(networkClient: NetworkClientProtocol, sessionManager: SessionManager) {
        self.networkClient  = networkClient
        self.sessionManager = sessionManager
    }

    func fetchAllProfiles() async throws -> [FullProfileResponseDTO] {
        try await networkClient.request(ProfileFetchEndpoint.allProfiles)
    }

    func fetchDefaultProfile() async throws -> FullProfileResponseDTO {
        try await networkClient.request(ProfileFetchEndpoint.defaultProfile)
    }

    /// Always calls PUT /api/v1/profiles/{id}.
    /// Also calls PUT /api/v1/users/me when the profileId matches the user's primary (default) profile.
    func updateProfile(id: String, params: ProfileUpdateRequestParams, image: UIImage?) async throws {
        let imageData     = image?.jpegData(compressionQuality: 0.7)
        let profileParams = params.asProfileTextParameters()

        let isPrimary = await (sessionManager.currentUser?.defaultProfileId == id)

        if isPrimary {
            let userParams = params.asUserTextParameters()
            async let profileUpdate: Void = networkClient.requestMultipartWithoutResponse(
                ProfileMutateEndpoint.updateProfile(id: id),
                textParameters: profileParams,
                fileData: imageData,
                fileFieldName: "profileImage",
                fileName: "profile.jpg",
                mimeType: "image/jpeg"
            )
            async let userUpdate: Void = networkClient.requestMultipartWithoutResponse(
                ProfileMutateEndpoint.updateUser,
                textParameters: userParams,
                fileData: imageData,
                fileFieldName: "profileImage",
                fileName: "profile.jpg",
                mimeType: "image/jpeg"
            )
            try await profileUpdate
            try await userUpdate
        } else {
            try await networkClient.requestMultipartWithoutResponse(
                ProfileMutateEndpoint.updateProfile(id: id),
                textParameters: profileParams,
                fileData: imageData,
                fileFieldName: "profileImage",
                fileName: "profile.jpg",
                mimeType: "image/jpeg"
            )
        }
    }

    func createProfile(params: ProfileUpdateRequestParams, image: UIImage?) async throws -> FullProfileResponseDTO {
        let imageData  = image?.jpegData(compressionQuality: 0.7)
        let textParams = params.asProfileTextParameters()
        return try await networkClient.requestMultipart(
            ProfileMutateEndpoint.createProfile,
            textParameters: textParams,
            fileData: imageData,
            fileFieldName: "profileImage",
            fileName: "profile.jpg",
            mimeType: "image/jpeg"
        )
    }

    func deleteProfile(id: String) async throws {
        try await networkClient.requestWithoutResponse(ProfileMutateEndpoint.deleteProfile(id: id))
    }
}
