//
//  EmergencyContactView.swift
//  Carely
//
//  Created by Mohamed Ayman on 19/07/2026.
//

import SwiftUI

struct EmergencyContactView: View {

    @StateObject private var viewModel: EmergencyContactViewModel

    init(viewModel: EmergencyContactViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.s24) {

                ProfileSetupHeaderView(
                    title: "Emergency Contact",
                    subtitle: "Who should we contact in case of an emergency? This information helps us ensure your safety during care visits."
                )

                VStack(spacing: Spacing.s16) {
                    CarelyTextField.name(
                        label: "Contact Name",
                        placeholder: "Full legal name",
                        text: $viewModel.contactName,
                        isRequired: true,
                        errorMessage: viewModel.contactNameError
                    )

                    CarelyTextField(
                        label: "Relationship",
                        placeholder: "Relationship",
                        text: $viewModel.relationship,
                        leadingIcon: "arrow.triangle.branch",
                        errorMessage: viewModel.relationshipError
                    )

                    CarelyTextField.phone(
                        label: "Phone Number",
                        placeholder: "(555) 000-0000",
                        text: $viewModel.phoneNumber,
                        isRequired: true,
                        errorMessage: viewModel.phoneNumberError
                    )

                    Spacer()

                    InfoBannerView(
                        text: "Your data is encrypted and only shared with medical professionals during active care sessions.",
                        iconName: "info.circle"
                    )
                }
                .padding(Spacing.s8)


            }
            .padding(.horizontal, Spacing.s16)
            .padding(.top, Spacing.s0)
            .padding(.bottom, Spacing.s16)
        }
        .background(Color.backGround)
        .safeAreaInset(edge: .bottom) {
            HealthProfileBottomActionsView(
                onBackTapped: viewModel.backTapped,
                onContinueTapped: viewModel.continueTapped
            )
        }
    }
}

#Preview("Emergency Contact - In Coordinator") {
    ProfileSetupCoordinatorView(
        coordinator: ProfileSetupCoordinator(
            data: ProfileSetupData(),
            startingStep: .emergencyContact
        ),
        container: DIContainer(),
        onFinish: {}
    )
}
