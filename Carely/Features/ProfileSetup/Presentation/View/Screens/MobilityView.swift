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

private extension MobilityView {

    var titleSection: some View {
        VStack(alignment: .leading, spacing: Spacing.s8) {
            Text("How is the patient's mobility?")
                .carelyText(style: .heading3, weight: .semiBold)
                .foregroundColor(.primaryFont)

            Text("This helps us assign the right equipment and specialist for the home visits.")
                .carelyText(style: .bodySmall, weight: .regular)
                .foregroundColor(.secondaryFont)
        }
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
#Preview("Medical History – In Coordinator") {
    ProfileSetupCoordinatorView(
        container: DIContainer(),
        coordinator: ProfileSetupCoordinator(
            data: ProfileSetupData(),
            startingStep: .medicalHistory
        ),
        onFinish: {}
    )
}
