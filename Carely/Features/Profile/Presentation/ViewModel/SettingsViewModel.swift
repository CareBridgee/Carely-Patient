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

    /// Drives the `.errorToast` for any settings-sync failure. Always the
    /// exact server message (via `error.carelyDescription`) rather than a
    /// hardcoded fallback string. No setting currently performs a server
    /// sync, so this stays `nil` today — it's wired up so any future sync
    /// call only needs to assign into it on failure.
    @Published var errorMessage: String? = nil
    @Published var showPrivacyPolicySheet: Bool = false

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
        showPrivacyPolicySheet = true
    }
}
