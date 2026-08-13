//
//  MedicalHistoryViewModel.swift
//  Carely
//
//  Created by Mohamed Ayman on 19/07/2026.
//

import Foundation

@MainActor
final class MedicalHistoryViewModel: ObservableObject {

    @Published var previousSurgeries: String
    @Published var previousHospitalizations: String

    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var showError: Bool = false

    private var initialData: MedicalHistory
    private let getProfileIdUseCase: GetDefaultProfileIdUseCase
    private let saveMedicalHistoryUseCase: SaveMedicalHistoryUseCase
    private let overrideProfileId: String?
    private let onContinue: (MedicalHistory) -> Void
    private let onBack: (MedicalHistory) -> Void

    init(
        existingData: MedicalHistory,
        getProfileIdUseCase: GetDefaultProfileIdUseCase,
        saveMedicalHistoryUseCase: SaveMedicalHistoryUseCase,
        overrideProfileId: String? = nil,
        onContinue: @escaping (MedicalHistory) -> Void,
        onBack: @escaping (MedicalHistory) -> Void
    ) {
        self.previousSurgeries = existingData.previousSurgeries
        self.previousHospitalizations = existingData.previousHospitalizations
        self.initialData = MedicalHistory(
            previousSurgeries: existingData.previousSurgeries.trimmingCharacters(in: .whitespacesAndNewlines),
            previousHospitalizations: existingData.previousHospitalizations.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        self.getProfileIdUseCase = getProfileIdUseCase
        self.saveMedicalHistoryUseCase = saveMedicalHistoryUseCase
        self.overrideProfileId = overrideProfileId
        self.onContinue = onContinue
        self.onBack = onBack
    }

    var history: MedicalHistory {
        MedicalHistory(
            previousSurgeries: previousSurgeries.trimmingCharacters(in: .whitespacesAndNewlines),
            previousHospitalizations: previousHospitalizations.trimmingCharacters(in: .whitespacesAndNewlines)
        )
    }

    func backTapped() {
        onBack(history)
    }

    func continueTapped() {
        let currentHistory = self.history
        if currentHistory == initialData || (currentHistory.previousSurgeries.isEmpty && currentHistory.previousHospitalizations.isEmpty) {
            onContinue(currentHistory)
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
                let profileId: String
                if let overrideProfileId {
                    profileId = overrideProfileId
                } else {
                    profileId = try await getProfileIdUseCase.execute()
                }
                try await saveMedicalHistoryUseCase.execute(profileId: profileId, history: currentHistory)

                self.isLoading = false
                self.onContinue(currentHistory)
            } catch {
                self.isLoading = false
                self.errorMessage = error.localizedDescription
                self.showError = true
            }
        }
    }
}
