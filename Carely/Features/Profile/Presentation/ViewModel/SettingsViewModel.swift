import Foundation
import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {

    @Published var patientName: String = ""
    @Published var language: String = "English"
    @Published var appearance: AppAppearance {
        didSet {
            appState.setAppearance(appearance)
        }
    }

    private let coordinator: ProfileCoordinator
    private let appState: AppState

    init(patientName: String, coordinator: ProfileCoordinator, appState: AppState) {
        self.patientName = patientName
        self.coordinator = coordinator
        self.appState = appState
        self.appearance = appState.appearance
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
