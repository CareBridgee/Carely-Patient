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
    let fetchConditions: FetchMedicalConditionsUseCase
    let syncConditions: SyncMedicalConditionsUseCase
    let saveConditions: SaveExistingConditionsUseCase
    let fetchAllergies: FetchAllergiesUseCase
    let syncAllergies: SyncAllergiesUseCase
    let saveAllergies: SaveAllergiesUseCase
    let fetchMedications: FetchMedicationsUseCase
    let syncMedications: SyncMedicationsUseCase
    let saveMedications: SaveMedicationsUseCase
    let saveHistory: SaveMedicalHistoryUseCase
    let fetchContact: FetchEmergencyContactUseCase
    let saveContact: SaveEmergencyContactUseCase
    let saveAddress: SaveHomeAddressUseCase
    let updateAddress: UpdateHomeAddressUseCase
    let fetchAddress: FetchHomeAddressUseCase
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

final class FetchMedicalConditionsUseCase {
    private let repo: ProfileSetupRepositoryProtocol
    init(repo: ProfileSetupRepositoryProtocol) { self.repo = repo }

    func execute(profileId: String) async throws -> ExistingConditions {
        async let availableTask = repo.fetchAllMedicalConditions()
        async let selectedTask = repo.fetchProfileMedicalConditions(profileId: profileId)

        let available = try await availableTask
        let selected = try await selectedTask

        return ExistingConditions(
            availableConditions: available,
            selectedConditionIds: selected
        )
    }
}

final class SyncMedicalConditionsUseCase {
    private let repo: ProfileSetupRepositoryProtocol
    init(repo: ProfileSetupRepositoryProtocol) { self.repo = repo }

    func execute(
        profileId: String,
        initialSelectedIds: Set<String>,
        currentSelectedIds: Set<String>,
        availableConditions: [MedicalCondition]
    ) async throws {
        let toAdd = currentSelectedIds.subtracting(initialSelectedIds)
        let toRemove = initialSelectedIds.subtracting(currentSelectedIds)

        if toAdd.isEmpty && toRemove.isEmpty { return }

        let conditionMap = Dictionary(uniqueKeysWithValues: availableConditions.map { ($0.id, $0) })

        for id in toAdd {
            if let cond = conditionMap[id] {
                try await repo.addMedicalCondition(profileId: profileId, condition: cond)
            }
        }

        for id in toRemove {
            try await repo.removeMedicalCondition(profileId: profileId, medicalConditionId: id)
        }
    }
}

final class SaveExistingConditionsUseCase {
    private let syncUseCase: SyncMedicalConditionsUseCase
    init(repo: ProfileSetupRepositoryProtocol) { self.syncUseCase = SyncMedicalConditionsUseCase(repo: repo) }

    func execute(
        profileId: String,
        initialSelectedIds: Set<String>,
        currentSelectedIds: Set<String>,
        availableConditions: [MedicalCondition]
    ) async throws {
        try await syncUseCase.execute(
            profileId: profileId,
            initialSelectedIds: initialSelectedIds,
            currentSelectedIds: currentSelectedIds,
            availableConditions: availableConditions
        )
    }
}

final class FetchAllergiesUseCase {
    private let repo: ProfileSetupRepositoryProtocol
    init(repo: ProfileSetupRepositoryProtocol) { self.repo = repo }

    func execute(profileId: String) async throws -> Allergies {
        async let availableTask = repo.fetchAllAllergies()
        async let selectedTask = repo.fetchProfileAllergies(profileId: profileId)

        let available = try await availableTask
        let selected = try await selectedTask

        return Allergies(
            availableAllergies: available,
            selectedAllergyIds: selected,
            hasNoKnownAllergies: false
        )
    }
}

final class SyncAllergiesUseCase {
    private let repo: ProfileSetupRepositoryProtocol
    init(repo: ProfileSetupRepositoryProtocol) { self.repo = repo }

    func execute(
        profileId: String,
        initialSelectedIds: Set<String>,
        currentSelectedIds: Set<String>,
        availableAllergies: [Allergy]
    ) async throws {
        let toAdd = currentSelectedIds.subtracting(initialSelectedIds)
        let toRemove = initialSelectedIds.subtracting(currentSelectedIds)

        if toAdd.isEmpty && toRemove.isEmpty { return }

        let allergyMap = Dictionary(uniqueKeysWithValues: availableAllergies.map { ($0.id, $0) })

        for id in toAdd {
            if let allergy = allergyMap[id] {
                try await repo.addAllergy(profileId: profileId, allergy: allergy)
            }
        }

        for id in toRemove {
            try await repo.removeAllergy(profileId: profileId, allergyId: id)
        }
    }
}

final class SaveAllergiesUseCase {
    private let syncUseCase: SyncAllergiesUseCase
    init(repo: ProfileSetupRepositoryProtocol) { self.syncUseCase = SyncAllergiesUseCase(repo: repo) }

    func execute(
        profileId: String,
        initialSelectedIds: Set<String>,
        currentSelectedIds: Set<String>,
        availableAllergies: [Allergy]
    ) async throws {
        try await syncUseCase.execute(
            profileId: profileId,
            initialSelectedIds: initialSelectedIds,
            currentSelectedIds: currentSelectedIds,
            availableAllergies: availableAllergies
        )
    }
}

final class FetchMedicationsUseCase {
    private let repo: ProfileSetupRepositoryProtocol
    init(repo: ProfileSetupRepositoryProtocol) { self.repo = repo }

    func execute(profileId: String) async throws -> CurrentMedication {
        let medications = try await repo.fetchProfileMedications(profileId: profileId)
        return CurrentMedication(
            hasNoCurrentMedications: medications.isEmpty,
            medications: medications,
            prescriptionPhotoData: nil
        )
    }
}

final class SyncMedicationsUseCase {
    private let repo: ProfileSetupRepositoryProtocol
    init(repo: ProfileSetupRepositoryProtocol) { self.repo = repo }

    func execute(
        profileId: String,
        initialMedications: [PatientMedication],
        currentMedications: [PatientMedication]
    ) async throws -> [PatientMedication] {
        let initialIds = Set(initialMedications.compactMap { $0.id.isEmpty ? nil : $0.id })
        let currentValid = currentMedications.filter { !$0.name.trimmingCharacters(in: .whitespaces).isEmpty }
        let currentIds = Set(currentValid.compactMap { $0.id.isEmpty ? nil : $0.id })

        let removedIds = initialIds.subtracting(currentIds)
        for medId in removedIds {
            try await repo.removeMedication(profileId: profileId, medicationId: medId)
        }

        var updatedList: [PatientMedication] = []
        for med in currentValid {
            let trimmedName = med.name.trimmingCharacters(in: .whitespaces)
            if med.id.isEmpty || !initialIds.contains(med.id) {
                let created = try await repo.addMedication(profileId: profileId, name: trimmedName)
                updatedList.append(created)
            } else {
                updatedList.append(med)
            }
        }

        return updatedList
    }
}

final class SaveMedicationsUseCase {
    private let syncUseCase: SyncMedicationsUseCase
    init(repo: ProfileSetupRepositoryProtocol) { self.syncUseCase = SyncMedicationsUseCase(repo: repo) }

    func execute(
        profileId: String,
        initialMedications: [PatientMedication],
        currentMedications: [PatientMedication]
    ) async throws -> [PatientMedication] {
        try await syncUseCase.execute(
            profileId: profileId,
            initialMedications: initialMedications,
            currentMedications: currentMedications
        )
    }
}

final class SaveMedicalHistoryUseCase {
    private let repo: ProfileSetupRepositoryProtocol
    init(repo: ProfileSetupRepositoryProtocol) { self.repo = repo }
    func execute(profileId: String, history: MedicalHistory) async throws {
        try await repo.saveMedicalHistory(profileId: profileId, history: history)
    }
}

final class FetchEmergencyContactUseCase {
    private let repo: ProfileSetupRepositoryProtocol
    init(repo: ProfileSetupRepositoryProtocol) { self.repo = repo }

    func execute(profileId: String) async throws -> EmergencyContact? {
        try await repo.fetchEmergencyContact(profileId: profileId)
    }
}

final class SaveEmergencyContactUseCase {
    private let repo: ProfileSetupRepositoryProtocol
    init(repo: ProfileSetupRepositoryProtocol) { self.repo = repo }

    func execute(profileId: String, contact: EmergencyContact) async throws {
        if let contactId = contact.id, !contactId.isEmpty {
            try await repo.updateEmergencyContact(contactId: contactId, contact: contact)
        } else {
            try await repo.saveEmergencyContact(profileId: profileId, contact: contact)
        }
    }
}

final class SaveHomeAddressUseCase {
    private let repo: ProfileSetupRepositoryProtocol
    init(repo: ProfileSetupRepositoryProtocol) { self.repo = repo }
    func execute(profileId: String, address: HomeAddress) async throws {
        try await repo.saveAddress(profileId: profileId, address: address)
    }
}

final class FetchHomeAddressUseCase {
    private let repo: ProfileSetupRepositoryProtocol
    init(repo: ProfileSetupRepositoryProtocol) { self.repo = repo }
    func execute(profileId: String) async throws -> HomeAddress? {
        try await repo.fetchAddress(profileId: profileId)
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
