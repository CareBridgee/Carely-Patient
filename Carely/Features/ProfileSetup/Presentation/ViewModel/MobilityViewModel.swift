//
//  MobilityViewModel.swift
//  Carely
//
//  Created by Mohamed Ayman on 19/07/2026.
//

import Foundation

@MainActor
final class MobilityViewModel: ObservableObject {

    @Published var status: MobilityStatus?
    @Published var additionalNotes: String

    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var showError: Bool = false

    private var initialData: Mobility
    private let getProfileIdUseCase: GetDefaultProfileIdUseCase
    private let updateMobilityUseCase: UpdateMobilityUseCase
    private let overrideProfileId: String?

    private let onContinue: (Mobility) -> Void
    private let onBack: (Mobility) -> Void

    init(
        existingData: Mobility,
        getProfileIdUseCase: GetDefaultProfileIdUseCase,
        updateMobilityUseCase: UpdateMobilityUseCase,
        overrideProfileId: String? = nil,
        onContinue: @escaping (Mobility) -> Void,
        onBack: @escaping (Mobility) -> Void
    ) {
        self.status = existingData.status
        self.additionalNotes = existingData.additionalNotes
        self.initialData = Mobility(
            status: existingData.status,
            additionalNotes: existingData.additionalNotes.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        self.getProfileIdUseCase = getProfileIdUseCase
        self.updateMobilityUseCase = updateMobilityUseCase
        self.overrideProfileId = overrideProfileId

        self.onContinue = onContinue
        self.onBack = onBack
    }

    var mobility: Mobility {
        Mobility(
            status: status,
            additionalNotes: additionalNotes.trimmingCharacters(in: .whitespacesAndNewlines)
        )
    }

    func select(_ status: MobilityStatus) {
        self.status = status
    }

    func backTapped() {
        onBack(mobility)
    }

    func continueTapped() {
        let currentMobility = self.mobility
        if currentMobility == initialData || (currentMobility.status == nil && currentMobility.additionalNotes.isEmpty) {
            onContinue(currentMobility)
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
                try await updateMobilityUseCase.execute(profileId: profileId, mobility: currentMobility)
                
                self.isLoading = false
                self.onContinue(currentMobility)
                
            } catch {
                self.isLoading = false
                self.errorMessage = error.localizedDescription
                self.showError = true
            }
        }
    }
}
