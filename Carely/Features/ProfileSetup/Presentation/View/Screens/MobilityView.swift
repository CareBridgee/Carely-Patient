//
//  MobilityView.swift
//  Carely
//
//  Created by Mohamed Ayman on 19/07/2026.
//

import SwiftUI

struct MobilityView: View {
    @StateObject var viewModel: MobilityViewModel

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: Spacing.s20) {
                titleSection
                optionsSection
                notesSection
            }
            .padding(.horizontal, Spacing.s16)
            .padding(.top, Spacing.s0)
            .padding(.bottom, Spacing.s16)
        }
        .safeAreaInset(edge: .bottom) {
            HealthProfileBottomActionsView(
                onBackTapped: viewModel.backTapped,
                onContinueTapped: viewModel.continueTapped
            )
        }
        .background(Color.backGround.ignoresSafeArea())
        .navigationBarHidden(true)
        .errorToast($viewModel.errorMessage)
    }
}

private extension MobilityView {

    var titleSection: some View {
        ProfileSetupHeaderView(
            title: "How is the patient's mobility?",
            subtitle: "This helps us assign the right equipment and specialist for the home visits."
        )
    }

    var optionsSection: some View {
        VStack(spacing: Spacing.s12) {
            ForEach(MobilityStatus.allCases, id: \.self) { status in
                MobilityOptionRow(
                    status: status,
                    isSelected: viewModel.status == status,
                    onTap: { viewModel.select(status) }
                )
            }
        }
    }

    var notesSection: some View {
        VStack(alignment: .leading, spacing: Spacing.s8) {
            Text("Additional Notes (Optional)")
                .carelyText(style: .bodySmall, weight: .medium)
                .foregroundColor(.secondaryFont)

            CustomTextAreaView(
                placeholder: "e.g. occasional falls, specific limb weakness...",
                text: $viewModel.additionalNotes,
                minHeight: 100
            )
        }
    }
}
//#Preview("Medical History – In Coordinator") {
//    ProfileSetupCoordinatorView(
//    
//        coordinator: ProfileSetupCoordinator(
//            data: ProfileSetupData(),
//            startingStep: .medicalHistory
//        ),
//        container: DIContainer(),
//        onFinish: {}
//    )
//}
