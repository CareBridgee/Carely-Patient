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

                VStack(alignment: .leading, spacing: Spacing.s16) {
                    Text("Emergency Contact")
                        .carelyText(style: .heading2, weight: .bold)
                        .foregroundColor(.primaryFont)

                    Text("Who should we contact in case of an emergency? This information helps us ensure your safety during care visits.")
                        .carelyText(style: .bodySmall, weight: .regular)
                        .foregroundColor(.secondaryFont)
                }

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

                VStack(spacing: Spacing.s12) {
                    PrimaryButton(title: "Continue to Final Step") {
                        viewModel.continueTapped()
                    }

                    SecondaryButton(title: "Back") {
                        viewModel.backTapped()
                    }
                }
            }
            .padding(Spacing.s20)
        }
        .background(Color.backGround)
    }
}
