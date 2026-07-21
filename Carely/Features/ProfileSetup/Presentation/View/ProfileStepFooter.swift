//
//  ProfileStepFooter.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 20/07/2026.
//


import SwiftUI

struct ProfileStepFooter: View {
    var showBack: Bool = true
    var continueTitle: String = "Continue"
    let onBack: () -> Void
    let onContinue: () -> Void

    var body: some View {
        HStack(spacing: Spacing.s12) {
            if showBack {
                SecondaryButton(title: "Back", action: onBack)
            }

            PrimaryButton(
                title: continueTitle,
                customIconSize: IconSize.s16,
                icon: "arrow.right",
                iconPosition: .trailing,
                action: onContinue
            )
        }
        .padding(.horizontal, Spacing.s16)
        .padding(.top, Spacing.s12)
        .background(Color.backGround)
    }
}