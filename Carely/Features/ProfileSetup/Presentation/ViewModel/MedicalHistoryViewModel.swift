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

    private let coordinator: ProfileSetupCoordinator

    init(coordinator: ProfileSetupCoordinator) {
        self.coordinator = coordinator
        self.previousSurgeries = coordinator.data.medicalHistory.previousSurgeries
        self.previousHospitalizations = coordinator.data.medicalHistory.previousHospitalizations
    }

    var showBackButton: Bool {
        !coordinator.isFirstStep
    }

    func backTapped() {
        persist()
        coordinator.previous()
    }

    func continueTapped() {
        persist()
        coordinator.next()
    }

    private func persist() {
        coordinator.save(
            medicalHistory: MedicalHistory(
                previousSurgeries: previousSurgeries.trimmingCharacters(in: .whitespacesAndNewlines),
                previousHospitalizations: previousHospitalizations.trimmingCharacters(in: .whitespacesAndNewlines)
            )
        )
    }
}
