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

    private let coordinator: ProfileSetupCoordinator

    init(coordinator: ProfileSetupCoordinator) {
        self.coordinator = coordinator
        self.status = coordinator.data.mobility.status
        self.additionalNotes = coordinator.data.mobility.additionalNotes
    }

    var showBackButton: Bool {
        !coordinator.isFirstStep
    }

    func select(_ status: MobilityStatus) {
        self.status = status
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
            mobility: Mobility(
                status: status,
                additionalNotes: additionalNotes.trimmingCharacters(in: .whitespacesAndNewlines)
            )
        )
    }
}
