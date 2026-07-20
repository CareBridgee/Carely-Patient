//
//  MedicalHistoryView.swift
//  Carely
//
//  Created by Mohamed Ayman on 19/07/2026.
//

import SwiftUI


struct MedicalHistoryView: View {
    @StateObject var viewModel: MedicalHistoryViewModel

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: Spacing.s16) {
                ProfileFieldCard(
                    icon: "bandage.fill",
                    title: "Previous Surgeries",
                    subtitle: "Optional • List procedure and year",
                    placeholder: "e.g. Appendectomy (2015), Knee Replacement (2021)...",
                    text: $viewModel.previousSurgeries
                )

                ProfileFieldCard(
                    icon: "cross.case.fill",
                    title: "Previous Hospitalizations",
                    subtitle: "Optional • Mention reason and duration",
                    placeholder: "e.g. Pneumonia treatment (2019, 5 days)...",
                    text: $viewModel.previousHospitalizations
                )

                InfoBannerView(
                    text: "Providing this information helps our care team prepare a more personalized assistance plan for you."
                )
            }
            .padding(.horizontal, Spacing.s16)
            .padding(.top, Spacing.s16)
            .padding(.bottom, Spacing.s16)
        }
        .safeAreaInset(edge: .bottom) {
            ProfileStepFooter(
                showBack: viewModel.showBackButton,
                onBack: viewModel.backTapped,
                onContinue: viewModel.continueTapped
            )
        }
        .background(Color.backGround.ignoresSafeArea())
    }
}
#Preview {
    MedicalHistoryView(
        viewModel: MedicalHistoryViewModel(
            coordinator: ProfileSetupCoordinator(
                data: ProfileSetupData(),
                startingStep: .medicalHistory
            )
        )
    )
}
