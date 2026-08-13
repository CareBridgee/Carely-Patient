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

    init(service: ProfileNetworkServiceProtocol) {
        self.service = service
    }

    // MARK: - Fetch

    func fetchPatientProfile() async throws -> PatientProfile {
        let dto = try await service.fetchDefaultProfile()
        return map(dto)
    }

    func fetchFamilyMembers() async throws -> [FamilyMember] {
        let all = try await service.fetchAllProfiles()
        return all
            .filter { ($0.isDeleted == false || $0.isDeleted == nil) && ($0.isPrimary == false) }
            .map { dto in
                let fullName = "\(dto.firstName ?? "") \(dto.lastName ?? "")".trimmingCharacters(in: .whitespaces)
                return FamilyMember(
                    id: dto.id,
                    name: fullName.isEmpty ? "Unknown" : fullName,
                    relation: dto.relationship?.capitalized ?? "Dependent",
                    profileImageUrl: dto.profileImageUrl
                )
            }
    }

    // MARK: - Mutate

    func updateProfile(id: String, params: ProfileUpdateRequestParams, image: UIImage?) async throws {
        try await service.updateProfile(id: id, params: params, image: image)
    }

    func createProfile(params: ProfileUpdateRequestParams, image: UIImage?) async throws -> PatientProfile {
        let dto = try await service.createProfile(params: params, image: image)
        return map(dto)
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
