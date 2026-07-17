import Foundation
import SwiftUI

@MainActor
final class ProfileSetupDecisionViewModel: ObservableObject {
    private let router: AuthRouter
    private let onAuthFinished: () -> Void

    init(router: AuthRouter, onAuthFinished: @escaping () -> Void) {
        self.router = router
        self.onAuthFinished = onAuthFinished
    }

    // MARK: - Intents

    func completeHealthProfileTapped() {
        // TODO: navigate to the health profile flow
    }

    func skipForNowTapped() {
        onAuthFinished()
    }
    
}
