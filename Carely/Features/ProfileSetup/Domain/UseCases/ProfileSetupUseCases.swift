//
//  ProfileSetupUseCases.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 28/07/2026.
//


import Foundation

struct ProfileSetupUseCases {
    let getProfileId: GetDefaultProfileIdUseCase
    let createFamilyMemberProfile: CreateFamilyMemberProfileUseCase
    let updateBasicInfo: UpdateBasicHealthInfoUseCase
    let updateMobility: UpdateMobilityUseCase
    let saveConditions: SaveExistingConditionsUseCase
    let saveAllergies: SaveAllergiesUseCase
    let saveMedications: SaveMedicationsUseCase
    let saveHistory: SaveMedicalHistoryUseCase
    let saveContact: SaveEmergencyContactUseCase
    let saveAddress: SaveHomeAddressUseCase
    let updateAddress: UpdateHomeAddressUseCase
}

protocol ProfileIdProviding {
    func execute() async throws -> String
}
final class GetDefaultProfileIdUseCase {
    private let repo: ProfileSetupRepositoryProtocol
    private let sessionManager: SessionManager
    
    init(repo: ProfileSetupRepositoryProtocol, sessionManager: SessionManager) {
        self.repo = repo
        self.sessionManager = sessionManager
    }
    
    func execute() async throws -> String {
        if let cachedId = await sessionManager.currentUser?.defaultProfileId {
            return cachedId
        }
        
        return try await repo.fetchDefaultProfileId()
    }
}

final class UpdateBasicHealthInfoUseCase {
    private let repo: ProfileSetupRepositoryProtocol
    init(repo: ProfileSetupRepositoryProtocol) { self.repo = repo }
    func execute(profileId: String, info: BasicHealthInfo) async throws {
        try await repo.updateBasicInfo(profileId: profileId, info: info)
    }
}

final class UpdateMobilityUseCase {
    private let repo: ProfileSetupRepositoryProtocol
    init(repo: ProfileSetupRepositoryProtocol) { self.repo = repo }
    func execute(profileId: String, mobility: Mobility) async throws {
        try await repo.updateMobility(profileId: profileId, mobility: mobility)
    }
}

final class SaveExistingConditionsUseCase {
    private let repo: ProfileSetupRepositoryProtocol
    init(repo: ProfileSetupRepositoryProtocol) { self.repo = repo }
    func execute(profileId: String, conditions: ExistingConditions) async throws {
        try await repo.saveMedicalConditions(profileId: profileId, conditions: conditions)
    }
}

final class SaveAllergiesUseCase {
    private let repo: ProfileSetupRepositoryProtocol
    init(repo: ProfileSetupRepositoryProtocol) { self.repo = repo }
    func execute(profileId: String, allergies: Allergies) async throws {
        try await repo.saveAllergies(profileId: profileId, allergies: allergies)
    }
}

final class SaveMedicationsUseCase {
    private let repo: ProfileSetupRepositoryProtocol
    init(repo: ProfileSetupRepositoryProtocol) { self.repo = repo }
    func execute(profileId: String, medications: CurrentMedication) async throws {
        try await repo.saveMedications(profileId: profileId, medications: medications)
    }
}

final class SaveMedicalHistoryUseCase {
    private let repo: ProfileSetupRepositoryProtocol
    init(repo: ProfileSetupRepositoryProtocol) { self.repo = repo }
    func execute(profileId: String, history: MedicalHistory) async throws {
        try await repo.saveMedicalHistory(profileId: profileId, history: history)
    }
}

final class SaveEmergencyContactUseCase {
    private let repo: ProfileSetupRepositoryProtocol
    init(repo: ProfileSetupRepositoryProtocol) { self.repo = repo }
    func execute(profileId: String, contact: EmergencyContact) async throws {
        try await repo.saveEmergencyContact(profileId: profileId, contact: contact)
    }
}

final class SaveHomeAddressUseCase {
    private let repo: ProfileSetupRepositoryProtocol
    init(repo: ProfileSetupRepositoryProtocol) { self.repo = repo }
    func execute(profileId: String, address: HomeAddress) async throws {
        try await repo.saveAddress(profileId: profileId, address: address)
    }
}
final class CreateFamilyMemberProfileUseCase {
    private let repo: ProfileSetupRepositoryProtocol
    init(repo: ProfileSetupRepositoryProtocol) { self.repo = repo }
    func execute(_ info: FamilyMemberBasicInfo) async throws -> String {
        try await repo.createFamilyMemberProfile(info)
    }
}
final class UpdateHomeAddressUseCase {
    private let repo: ProfileSetupRepositoryProtocol
    init(repo: ProfileSetupRepositoryProtocol) { self.repo = repo }
    func execute(profileId: String, address: HomeAddress) async throws {
        try await repo.updateAddress(profileId: profileId, address: address)
    }
}
extension GetDefaultProfileIdUseCase: ProfileIdProviding {}

final class FixedProfileIdProvider: ProfileIdProviding {
    private let profileId: String
    init(profileId: String) { self.profileId = profileId }
    func execute() async throws -> String { profileId }
}
