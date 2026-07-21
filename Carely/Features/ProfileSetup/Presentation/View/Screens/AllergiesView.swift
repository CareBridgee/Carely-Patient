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
            AppHeader(title: "CareConnect", trailingIcon: "person.fill") {}
                .padding(.horizontal, Spacing.s16)

            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.s24) {

                    VStack(alignment: .leading, spacing: Spacing.s8) {
                        Text("Allergies & Sensitivities")
                            .carelyText(style: .heading2, weight: .semiBold)
                            .foregroundColor(.primaryFont)

                        Text("Please specify any allergies to ensure your care plan is safe and effective.")
                            .carelyText(style: .bodyRegular)
                            .foregroundColor(.secondaryFont)
                    }

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
                .padding(.top, Spacing.s24)
                .padding(.bottom, Spacing.s24)
            }

            footerButtons
                .padding(.horizontal, Spacing.s16)
                .padding(.vertical, Spacing.s16)
        }
        .background(Color.backGround.ignoresSafeArea())
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
        .clipShape(RoundedRectangle.trueFit(Radius.r16))
        .overlay(
            RoundedRectangle.trueFit(Radius.r16)
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
                    .frame(width: IconSize.s20, height: IconSize.s20)
                    .foregroundColor(.brandPrimary)

                Text(title)
                    .carelyText(style: .bodyLarge, weight: .semiBold)
                    .foregroundColor(.primaryFont)
            }

            FlowLayout(spacing: Spacing.s8, lineSpacing: Spacing.s8) {
                ForEach(options, id: \.self) { option in
                    Button {
                        onTap(option)
                    } label: {
                        SecondaryChip(
                            title: option,
                            isSelected: isSelected(option)
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
                    .frame(width: IconSize.s20, height: IconSize.s20)
                    .foregroundColor(.brandPrimary)

                Text("Other allergies")
                    .carelyText(style: .bodyLarge, weight: .semiBold)
                    .foregroundColor(.primaryFont)
            }

            CustomTextAreaView(
                placeholder: "Enter environmental, seasonal, or other specific allergies...",
                text: $viewModel.otherAllergiesText,
                minHeight: 100
            )
        }
    }

    private var footerButtons: some View {
        GeometryReader { geometry in
            let spacing = Spacing.s12
            let availableWidth = geometry.size.width - spacing
            let backWidth = availableWidth * 0.25
            let continueWidth = availableWidth * 0.75

            HStack(spacing: spacing) {
                SecondaryButton(title: "Back", isFullWidth: true, action: viewModel.backTapped)
                    .frame(width: backWidth)

                PrimaryButton(title: "Continue", action: viewModel.continueTapped)
                    .frame(width: continueWidth)
            }
        }
        .frame(height: Spacing.s48)
    }
}

//#Preview {
//    AllergiesView(
//        viewModel: AllergiesViewModel(
//            coordinator: ProfileSetupCoordinator(data: ProfileSetupData())
//        )
//    )
//}
