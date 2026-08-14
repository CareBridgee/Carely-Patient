//
//  ProfileRepositoryImpl.swift
//  Carely
//
//  Created by Mina on 25/07/2026.
//

import Foundation
import UIKit

final class ProfileRepositoryImpl: ProfileRepositoryProtocol {

    private let service: ProfileNetworkServiceProtocol
    private let store: PatientProfilesStore
    private let sessionManager: SessionManager

    init(service: ProfileNetworkServiceProtocol, store: PatientProfilesStore, sessionManager: SessionManager) {
        self.service = service
        self.store = store
        self.sessionManager = sessionManager
    }

    // MARK: - Fetch

    func fetchPatientProfile() async throws -> PatientProfile {
        let dto = try await service.fetchDefaultProfile()
        let profile = map(dto)
        await MainActor.run { store.setPrimaryProfile(profile) }
        return profile
    }

    func fetchFamilyMembers() async throws -> [FamilyMember] {
        let all = try await service.fetchAllProfiles()
        let members = all
            .filter { ($0.isDeleted == false || $0.isDeleted == nil) && ($0.isPrimary == false) }
            .map { dto in
                let fullName = "\(dto.firstName ?? "") \(dto.lastName ?? "")".trimmingCharacters(in: .whitespaces)
                let rel = (dto.relationship?.trimmingCharacters(in: .whitespaces).isEmpty == false) ? dto.relationship!.capitalized : "Family Member"
                return FamilyMember(
                    id: dto.id,
                    name: fullName.isEmpty ? "Unknown" : fullName,
                    relation: rel,
                    profileImageUrl: dto.profileImageUrl
                )
            }
        await MainActor.run { store.setFamilyMembers(members) }
        return members
    }

    // MARK: - Mutate

    func updateProfile(id: String, params: ProfileUpdateRequestParams, image: UIImage?) async throws {
        let dto = try await service.updateProfile(id: id, params: params, image: image)
        let profile = map(dto)
        let fullName = "\(dto.firstName ?? "") \(dto.lastName ?? "")".trimmingCharacters(in: .whitespaces)
        let rel = (dto.relationship?.trimmingCharacters(in: .whitespaces).isEmpty == false) ? dto.relationship!.capitalized : "Family Member"
        let familyMember = FamilyMember(
            id: dto.id,
            name: fullName.isEmpty ? "Unknown" : fullName,
            relation: rel,
            profileImageUrl: dto.profileImageUrl
        )
        await MainActor.run { 
            if profile.isPrimary {
                store.setPrimaryProfile(profile)
                if var currentUser = sessionManager.currentUser {
                    currentUser.firstName = dto.firstName ?? currentUser.firstName
                    currentUser.lastName = dto.lastName ?? currentUser.lastName
                    currentUser.dateOfBirth = dto.dateOfBirth ?? currentUser.dateOfBirth
                    currentUser.gender = dto.gender ?? currentUser.gender
                    currentUser.profileImageUrl = dto.profileImageUrl ?? currentUser.profileImageUrl
                    sessionManager.updateUser(currentUser)
                }
            } else {
                store.updateFamilyMember(familyMember)
            }
        }
    }

    func createProfile(params: ProfileUpdateRequestParams, image: UIImage?) async throws -> PatientProfile {
        let dto = try await service.createProfile(params: params, image: image)
        let profile = map(dto)
        let fullName = "\(dto.firstName ?? "") \(dto.lastName ?? "")".trimmingCharacters(in: .whitespaces)
        let rel = (dto.relationship?.trimmingCharacters(in: .whitespaces).isEmpty == false) ? dto.relationship!.capitalized : "Family Member"
        let familyMember = FamilyMember(
            id: dto.id,
            name: fullName.isEmpty ? "Unknown" : fullName,
            relation: rel,
            profileImageUrl: dto.profileImageUrl
        )
        await MainActor.run { 
            if !profile.isPrimary {
                store.addFamilyMember(familyMember)
            }
        }
        return profile
    }
    func deleteProfile(id: String) async throws {
        try await service.deleteProfile(id: id)
        await MainActor.run { store.removeFamilyMember(id: id) }
    }

    // MARK: - Mapping

    private func map(_ dto: FullProfileResponseDTO) -> PatientProfile {
        PatientProfile(
            id: dto.id,
            firstName: dto.firstName ?? "",
            lastName: dto.lastName ?? "",
            relationship: dto.relationship,
            gender: dto.gender,
            dateOfBirth: dto.dateOfBirth,
            bloodType: dto.bloodType,
            height: dto.height,
            weight: dto.weight,
            mobilityStatus: dto.mobilityStatus,
            mobilityNotes: dto.mobilityNotes,
            previousSurgeries: dto.previousSurgeries,
            previousHospitalizations: dto.previousHospitalizations,
            profileImageUrl: dto.profileImageUrl,
            isPrimary: dto.isPrimary ?? false
        )
    }
}
