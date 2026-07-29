import Foundation

struct ProfileSetupUseCases {
    let getProfileId: GetDefaultProfileIdUseCase
    let updateBasicInfo: UpdateBasicHealthInfoUseCase
    let updateMobility: UpdateMobilityUseCase
    let saveConditions: SaveExistingConditionsUseCase
    let saveAllergies: SaveAllergiesUseCase
    let saveMedications: SaveMedicationsUseCase
    let saveHistory: SaveMedicalHistoryUseCase
    let saveContact: SaveEmergencyContactUseCase
    let saveAddress: SaveHomeAddressUseCase
}

// Implementations:
final class GetDefaultProfileIdUseCase {
    private let repo: ProfileSetupRepositoryProtocol
    init(repo: ProfileSetupRepositoryProtocol) { self.repo = repo }
    func execute() async throws -> String { try await repo.fetchDefaultProfileId() }
}

final class UpdateBasicHealthInfoUseCase {
    private let repo: ProfileSetupRepositoryProtocol
    init(repo: ProfileSetupRepositoryProtocol) { self.repo = repo }
    func execute(profileId: String, info: BasicHealthInfo) async throws { try await repo.updateBasicInfo(profileId: profileId, info: info) }
}

final class SaveMedicalHistoryUseCase {
    private let repo: ProfileSetupRepositoryProtocol
    init(repo: ProfileSetupRepositoryProtocol) { self.repo = repo }
    func execute(profileId: String, history: MedicalHistory) async throws { try await repo.saveMedicalHistory(profileId: profileId, history: history) }
}

// ... [Repeat exact same 1-line wrapper pattern for Mobility, Conditions, Allergies, Medications, Contact, Address] ...