//
//  SettingsViewModel.swift
//  Carely
//
//  Created by Mina on 25/07/2026.
//

import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {

    @Published var patientName: String = ""
    @Published var language: String = "English"
    @Published var isDarkModeOn: Bool = false
    @Published var isEmailUpdatesOn: Bool = true
    @Published var isSMSAlertsOn: Bool = false

    private let coordinator: ProfileCoordinator

    init(patientName: String, coordinator: ProfileCoordinator) {
        self.patientName = patientName
        self.coordinator = coordinator
    }

    // MARK: - Navigation

    func backTapped() {
        coordinator.pop()
    }

    func languageTapped() {
        //
    }

    func privacyPolicyTapped() {
        //
    }
}
