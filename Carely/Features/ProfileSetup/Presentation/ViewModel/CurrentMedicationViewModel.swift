//
//  CurrentMedicationViewModel.swift
//  Carely
//

import Foundation

@MainActor
final class CurrentMedicationViewModel: ObservableObject {

    @Published var hasNoCurrentMedications: Bool = false
    @Published var medications: [PatientMedication] = []
    @Published var prescriptionPhotoData: Data?

    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var showError: Bool = false

    private var initialMedications: [PatientMedication] = []
    private let coordinator: ProfileSetupCoordinator
    private let getProfileIdUseCase: ProfileIdProviding?
    private let fetchMedicationsUseCase: FetchMedicationsUseCase?
    private let syncMedicationsUseCase: SyncMedicationsUseCase?
    private let overrideProfileId: String?

    init(
        coordinator: ProfileSetupCoordinator,
        getProfileIdUseCase: ProfileIdProviding? = nil,
        fetchMedicationsUseCase: FetchMedicationsUseCase? = nil,
        syncMedicationsUseCase: SyncMedicationsUseCase? = nil,
        overrideProfileId: String? = nil
    ) {
        self.coordinator = coordinator
        self.getProfileIdUseCase = getProfileIdUseCase
        self.fetchMedicationsUseCase = fetchMedicationsUseCase
        self.syncMedicationsUseCase = syncMedicationsUseCase
        self.overrideProfileId = overrideProfileId

        let existing = coordinator.data.currentMedication
        self.hasNoCurrentMedications = existing.hasNoCurrentMedications
        self.medications = existing.medications.isEmpty ? [PatientMedication()] : existing.medications
        self.initialMedications = existing.medications
        self.prescriptionPhotoData = existing.prescriptionPhotoData
    }

    func onAppear() {
        guard let fetchUseCase = fetchMedicationsUseCase else { return }
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let profileId = try await resolveProfileId()
                let loaded = try await fetchUseCase.execute(profileId: profileId)
                self.hasNoCurrentMedications = loaded.hasNoCurrentMedications
                self.medications = loaded.medications.isEmpty ? [PatientMedication()] : loaded.medications
                self.initialMedications = loaded.medications
                self.isLoading = false
            } catch {
                self.isLoading = false
            }
        }
    }

    var currentMedication: CurrentMedication {
        CurrentMedication(
            hasNoCurrentMedications: hasNoCurrentMedications,
            medications: medications,
            prescriptionPhotoData: prescriptionPhotoData
        )
    }

    func addMedicationTapped() {
        medications.append(PatientMedication())
        hasNoCurrentMedications = false
    }

    func removeMedication(_ entry: PatientMedication) {
        medications.removeAll { $0.id == entry.id && $0.name == entry.name }
        if medications.isEmpty {
            medications.append(PatientMedication())
        }
    }

    func toggleNoCurrentMedications() {
        hasNoCurrentMedications.toggle()
        if hasNoCurrentMedications {
            medications = [PatientMedication()]
            prescriptionPhotoData = nil
        }
    }

    func prescriptionPhotoPicked(_ data: Data?) {
        prescriptionPhotoData = data
    }

    func backTapped() {
        coordinator.save(currentMedication: currentMedication)
        let validCurrent = medications.filter { !$0.name.trimmingCharacters(in: .whitespaces).isEmpty }
        if validCurrent == initialMedications {
            coordinator.previous()
            return
        }
        performSync { [weak self] in
            self?.coordinator.previous()
        }
    }

    func continueTapped() {
        coordinator.save(currentMedication: currentMedication)
        let validCurrent = medications.filter { !$0.name.trimmingCharacters(in: .whitespaces).isEmpty }
        if validCurrent == initialMedications {
            coordinator.next()
            return
        }
        performSync { [weak self] in
            self?.coordinator.next()
        }
    }

    private func performSync(onSuccess: @escaping () -> Void) {
        guard let syncUseCase = syncMedicationsUseCase else {
            initialMedications = medications.filter { !$0.name.trimmingCharacters(in: .whitespaces).isEmpty }
            onSuccess()
            return
        }

        guard NetworkMonitor.shared.isConnected else {
            self.errorMessage = "No internet connection. Please check your network."
            self.showError = true
            return
        }

        isLoading = true
        errorMessage = nil

        Task {
            do {
                let profileId = try await resolveProfileId()
                let synced = try await syncUseCase.execute(
                    profileId: profileId,
                    initialMedications: initialMedications,
                    currentMedications: medications
                )

                self.initialMedications = synced
                self.medications = synced.isEmpty ? [PatientMedication()] : synced
                self.isLoading = false
                onSuccess()
            } catch {
                self.isLoading = false
                self.errorMessage = error.localizedDescription
                self.showError = true
            }
        }
    }

    private func resolveProfileId() async throws -> String {
        if let overrideProfileId, !overrideProfileId.isEmpty {
            return overrideProfileId
        } else if let getProfileIdUseCase {
            return try await getProfileIdUseCase.execute()
        }
        return ""
    }
}
