//
//  AllergiesViewModel.swift
//  Carely
//

import Foundation

@MainActor
final class AllergiesViewModel: ObservableObject {
    @Published var availableAllergies: [Allergy] = []
    @Published var selectedAllergyIds: Set<String> = []
    @Published var hasNoKnownAllergies: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var showError: Bool = false

    private var initialSelectedAllergyIds: Set<String> = []
    private let coordinator: ProfileSetupCoordinator
    private let getProfileIdUseCase: ProfileIdProviding?
    private let fetchAllergiesUseCase: FetchAllergiesUseCase?
    private let syncAllergiesUseCase: SyncAllergiesUseCase?
    private let overrideProfileId: String?

    init(
        coordinator: ProfileSetupCoordinator,
        getProfileIdUseCase: ProfileIdProviding? = nil,
        fetchAllergiesUseCase: FetchAllergiesUseCase? = nil,
        syncAllergiesUseCase: SyncAllergiesUseCase? = nil,
        overrideProfileId: String? = nil
    ) {
        self.coordinator = coordinator
        self.getProfileIdUseCase = getProfileIdUseCase
        self.fetchAllergiesUseCase = fetchAllergiesUseCase
        self.syncAllergiesUseCase = syncAllergiesUseCase
        self.overrideProfileId = overrideProfileId

        let existing = coordinator.data.allergies
        self.availableAllergies = existing.availableAllergies
        self.selectedAllergyIds = existing.selectedAllergyIds
        self.initialSelectedAllergyIds = existing.selectedAllergyIds
        self.hasNoKnownAllergies = existing.hasNoKnownAllergies
    }

    func onAppear() {
        guard let fetchUseCase = fetchAllergiesUseCase else { return }
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let profileId = try await resolveProfileId()
                let loaded = try await fetchUseCase.execute(profileId: profileId)
                self.availableAllergies = loaded.availableAllergies
                self.selectedAllergyIds = loaded.selectedAllergyIds
                self.initialSelectedAllergyIds = loaded.selectedAllergyIds
                self.isLoading = false
            } catch {
                self.isLoading = false
            }
        }
    }

    func allergies(for type: AllergyType) -> [Allergy] {
        availableAllergies.filter { $0.type == type }
    }

    func toggleAllergy(_ allergyId: String) {
        if selectedAllergyIds.contains(allergyId) {
            selectedAllergyIds.remove(allergyId)
        } else {
            selectedAllergyIds.insert(allergyId)
        }
        if !selectedAllergyIds.isEmpty {
            hasNoKnownAllergies = false
        }
    }

    func isSelected(_ allergyId: String) -> Bool {
        selectedAllergyIds.contains(allergyId)
    }

    func toggleNoKnownAllergies() {
        hasNoKnownAllergies.toggle()
        if hasNoKnownAllergies {
            selectedAllergyIds.removeAll()
        }
    }

    var currentAllergies: Allergies {
        Allergies(
            availableAllergies: availableAllergies,
            selectedAllergyIds: selectedAllergyIds,
            hasNoKnownAllergies: hasNoKnownAllergies
        )
    }

    func backTapped() {
        coordinator.save(allergies: currentAllergies)
        if selectedAllergyIds == initialSelectedAllergyIds {
            coordinator.previous()
            return
        }
        performSync { [weak self] in
            self?.coordinator.previous()
        }
    }

    func continueTapped() {
        coordinator.save(allergies: currentAllergies)
        if selectedAllergyIds == initialSelectedAllergyIds {
            coordinator.next()
            return
        }
        performSync { [weak self] in
            self?.coordinator.next()
        }
    }

    private func performSync(onSuccess: @escaping () -> Void) {
        guard let syncUseCase = syncAllergiesUseCase else {
            initialSelectedAllergyIds = selectedAllergyIds
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
                try await syncUseCase.execute(
                    profileId: profileId,
                    initialSelectedIds: initialSelectedAllergyIds,
                    currentSelectedIds: selectedAllergyIds,
                    availableAllergies: availableAllergies
                )

                self.initialSelectedAllergyIds = self.selectedAllergyIds
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
