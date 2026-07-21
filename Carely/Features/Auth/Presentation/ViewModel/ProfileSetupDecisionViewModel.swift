import Foundation
import SwiftUI

@MainActor
final class ProfileSetupDecisionViewModel: ObservableObject {

    private let oncompleteHealthProfileClicked: () -> Void
    private let onSkipButtonClicked: () -> Void

    init(
        oncompleteHealthProfileClicked: @escaping () -> Void,
        onSkipButtonClicked: @escaping () -> Void
    ) {
        self.oncompleteHealthProfileClicked = oncompleteHealthProfileClicked
        self.onSkipButtonClicked = onSkipButtonClicked
    }

    // MARK: - Intents

    func completeHealthProfileTapped() {
        oncompleteHealthProfileClicked()
    }

    func skipForNowTapped() {
        onSkipButtonClicked()
    }
}
