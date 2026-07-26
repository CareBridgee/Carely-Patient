//
//  AllergiesView.swift
//  Carely
//
//  Created by Mohamed Ayman on 19/07/2026.
//

import SwiftUI

struct AllergiesView: View {

    @StateObject private var viewModel: AllergiesViewModel

    init(viewModel: AllergiesViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.s24) {

                    ProfileSetupHeaderView(
                        title: "Allergies & Sensitivities",
                        subtitle: "Please specify any allergies to ensure your care plan is safe and effective."
                    )

                    noKnownAllergiesToggle

                    allergySection(
                        icon: "cross.case.fill",
                        title: "Drug Allergies",
                        options: viewModel.drugAllergyOptions,
                        isSelected: { viewModel.selectedDrugAllergies.contains($0) },
                        onTap: viewModel.toggleDrugAllergy
                    )
                    .disabled(viewModel.hasNoKnownAllergies)

                    allergySection(
                        icon: "fork.knife",
                        title: "Food Allergies",
                        options: viewModel.foodAllergyOptions,
                        isSelected: { viewModel.selectedFoodAllergies.contains($0) },
                        onTap: viewModel.toggleFoodAllergy
                    )
                    .disabled(viewModel.hasNoKnownAllergies)

                    otherAllergiesSection
                        .disabled(viewModel.hasNoKnownAllergies)
                }
                .padding(.horizontal, Spacing.s16)
                .padding(.top, Spacing.s0)
                .padding(.bottom, Spacing.s24)
            }
        }
        .background(Color.backGround.ignoresSafeArea())
        .safeAreaInset(edge: .bottom) {
            HealthProfileBottomActionsView(
                onBackTapped: viewModel.backTapped,
                onContinueTapped: viewModel.continueTapped
            )
        }
        .careConnectNavigationBar(title: "CareConnect", trailingIcon: "person.fill")
    }

    private var noKnownAllergiesToggle: some View {
        HStack(spacing: Spacing.s12) {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: IconSize.s24, height: IconSize.s24)
                .foregroundColor(.success)

            VStack(alignment: .leading, spacing: Spacing.s2) {
                Text("No known allergies")
                    .carelyText(style: .bodyRegular, weight: .semiBold)
                    .foregroundColor(.primaryFont)

                Text("I don't have any drug or food allergies")
                    .carelyText(style: .bodySmall)
                    .foregroundColor(.secondaryFont)
            }

            Spacer(minLength: Spacing.s8)

            Toggle("", isOn: $viewModel.hasNoKnownAllergies)
                .labelsHidden()
                .tint(.success)
        }
        .padding(Spacing.s16)
        .background(Color.surface)
        .clipShape(RoundedRectangle.carely(Radius.r16))
        .overlay(
            RoundedRectangle.carely(Radius.r16)
                .stroke(viewModel.hasNoKnownAllergies ? Color.success : Color.divider, lineWidth: 1)
        )
    }

    @ViewBuilder
    private func allergySection(
        icon: String,
        title: String,
        options: [String],
        isSelected: @escaping (String) -> Bool,
        onTap: @escaping (String) -> Void
    ) -> some View {
        VStack(alignment: .leading, spacing: Spacing.s12) {
            HStack(spacing: Spacing.s8) {
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: IconSize.s16, height: IconSize.s16)
                    .foregroundColor(.brandPrimary)

                Text(title)
                    .carelyText(style: .bodyRegular, weight: .medium)
                    .foregroundColor(.primaryFont)
            }

            FlowLayout(spacing: Spacing.s8, lineSpacing: Spacing.s8) {
                ForEach(options, id: \.self) { option in
                    Button {
                        onTap(option)
                    } label: {
                        SecondaryChip(
                            title: option,
                            isSelected: isSelected(option),
                            textStyle: .bodySmall,
                            paddingHorizontal: 12,
                            paddingVertical: 8
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var otherAllergiesSection: some View {
        VStack(alignment: .leading, spacing: Spacing.s12) {
            HStack(spacing: Spacing.s8) {
                Image(systemName: "square.and.pencil")
                    .resizable()
                    .scaledToFit()
                    .frame(width: IconSize.s16, height: IconSize.s16)
                    .foregroundColor(.brandPrimary)

                Text("Other allergies")
                    .carelyText(style: .bodyRegular, weight: .medium)
                    .foregroundColor(.primaryFont)
            }

            CustomTextAreaView(
                placeholder: "Enter environmental, seasonal, or other specific allergies...",
                text: $viewModel.otherAllergiesText,
                minHeight: 100
            )
        }
    }


}

#Preview("Allergies - In Coordinator") {
    ProfileSetupCoordinatorView(
        coordinator: ProfileSetupCoordinator(
            data: ProfileSetupData(),
            startingStep: .allergies
        ),
        container: DIContainer(),
        onFinish: {}
    )
}
