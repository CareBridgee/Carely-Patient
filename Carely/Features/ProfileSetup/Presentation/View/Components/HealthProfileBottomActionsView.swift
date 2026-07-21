import SwiftUI

struct HealthProfileBottomActionsView: View {
    var isContinueDisabled: Bool = false
    var onBackTapped: () -> Void
    var onContinueTapped: () -> Void
    
    var body: some View {
        HStack(spacing: Spacing.s16) {
            SecondaryButton(
                title: "Back",
                isFullWidth: false,
                fontWeight: .regular,
                action: onBackTapped
            )
            
            PrimaryButton(
                title: "Continue",
                customIconSize: 14,
                icon: "chevron.right",
                iconPosition: .trailing,
                action: onContinueTapped
            ).disabled(isContinueDisabled)
            .opacity(isContinueDisabled ? 0.5 : 1.0)
        }
        .padding(.horizontal, Spacing.s20)
        .padding(.vertical, Spacing.s16)
        .background(Color.surface)
    }
}
