//
//  ExistingConditionsViewModel.swift
//  Carely
//

import Foundation

@MainActor
final class ExistingConditionsViewModel: ObservableObject {
    @Published var availableConditions: [MedicalCondition] = []
    @Published var selectedConditionIds: Set<String> = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var showError: Bool = false

    private var initialSelectedConditionIds: Set<String> = []
    private let getProfileIdUseCase: ProfileIdProviding?
    private let fetchConditionsUseCase: FetchMedicalConditionsUseCase?
    private let syncConditionsUseCase: SyncMedicalConditionsUseCase?
    private let overrideProfileId: String?
    private let onContinue: (ExistingConditions) -> Void
    private let onBack: (ExistingConditions) -> Void

    init(
        existingData: ExistingConditions,
        getProfileIdUseCase: ProfileIdProviding? = nil,
        fetchConditionsUseCase: FetchMedicalConditionsUseCase? = nil,
        syncConditionsUseCase: SyncMedicalConditionsUseCase? = nil,
        overrideProfileId: String? = nil,
        onContinue: @escaping (ExistingConditions) -> Void = { _ in },
        onBack: @escaping (ExistingConditions) -> Void = { _ in }
    ) {
        self.availableConditions = existingData.availableConditions
        self.selectedConditionIds = existingData.selectedConditionIds
        self.initialSelectedConditionIds = existingData.selectedConditionIds
        self.getProfileIdUseCase = getProfileIdUseCase
        self.fetchConditionsUseCase = fetchConditionsUseCase
        self.syncConditionsUseCase = syncConditionsUseCase
        self.overrideProfileId = overrideProfileId
        self.onContinue = onContinue
        self.onBack = onBack
    }

    func onAppear() {
        guard let fetchUseCase = fetchConditionsUseCase else { return }
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let profileId = try await resolveProfileId()
                let loaded = try await fetchUseCase.execute(profileId: profileId)
                self.availableConditions = loaded.availableConditions
                self.selectedConditionIds = loaded.selectedConditionIds
                self.initialSelectedConditionIds = loaded.selectedConditionIds
                self.isLoading = false
            } catch {
                self.isLoading = false
            }
        }
    }

    func toggleCondition(_ conditionId: String) {
        if selectedConditionIds.contains(conditionId) {
            selectedConditionIds.remove(conditionId)
        } else {
            selectedConditionIds.insert(conditionId)
        }
    }

    func isSelected(_ conditionId: String) -> Bool {
        selectedConditionIds.contains(conditionId)
    }

    var existingConditionsData: ExistingConditions {
        ExistingConditions(availableConditions: availableConditions, selectedConditionIds: selectedConditionIds)
    }

    func backTapped() {
        if selectedConditionIds == initialSelectedConditionIds {
            onBack(existingConditionsData)
            return
        }
        performSync(onSuccess: onBack)
    }

    func continueTapped() {
        if selectedConditionIds == initialSelectedConditionIds {
            onContinue(existingConditionsData)
            return
        }
        performSync(onSuccess: onContinue)
    }

    private func performSync(onSuccess: @escaping (ExistingConditions) -> Void) {
        guard let syncUseCase = syncConditionsUseCase else {
            initialSelectedConditionIds = selectedConditionIds
            onSuccess(existingConditionsData)
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
                    initialSelectedIds: initialSelectedConditionIds,
                    currentSelectedIds: selectedConditionIds,
                    availableConditions: availableConditions
                )

                self.initialSelectedConditionIds = self.selectedConditionIds
                self.isLoading = false
                onSuccess(self.existingConditionsData)
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
