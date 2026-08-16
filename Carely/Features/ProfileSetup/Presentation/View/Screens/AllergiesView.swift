//
//  AllergiesView.swift
//  Carely
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

                    if viewModel.isLoading && viewModel.availableAllergies.isEmpty {
                        VStack(alignment: .leading, spacing: Spacing.s20) {
                            ForEach(0..<2, id: \.self) { _ in
                                VStack(alignment: .leading, spacing: Spacing.s12) {
                                    HStack(spacing: Spacing.s8) {
                                        EtmaenSkeletonCircle(size: 16)
                                        EtmaenSkeletonRect(width: 100, height: 16, radius: Radius.r8)
                                    }
                                    HStack(spacing: Spacing.s8) {
                                        EtmaenSkeletonRect(width: 80, height: 32, radius: 16)
                                        EtmaenSkeletonRect(width: 110, height: 32, radius: 16)
                                        EtmaenSkeletonRect(width: 90, height: 32, radius: 16)
                                    }
                                }
                            }
                        }
                    } else {
                        ForEach(AllergyType.allCases, id: \.self) { type in
                            let options = viewModel.allergies(for: type)
                            if !options.isEmpty {
                                allergySection(
                                    icon: categoryIcon(for: type),
                                    title: type.displayName,
                                    options: options
                                )
                                .disabled(viewModel.hasNoKnownAllergies)
                            }
                        }
                    }
                }
                .padding(.horizontal, Spacing.s16)
                .padding(.top, Spacing.s0)
                .padding(.bottom, Spacing.s24)
            }
        }
        .background(Color.backGround.ignoresSafeArea())
        .navigationBarHidden(true)
        .onAppear {
            viewModel.onAppear()
        }
        .errorToast($viewModel.errorMessage)
        .safeAreaInset(edge: .bottom) {
            HealthProfileBottomActionsView(
                onBackTapped: viewModel.backTapped,
                onContinueTapped: viewModel.continueTapped
            )
        }
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

            Toggle("", isOn: Binding(
                get: { viewModel.hasNoKnownAllergies },
                set: { _ in viewModel.toggleNoKnownAllergies() }
            ))
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
        options: [Allergy]
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
                ForEach(options) { allergy in
                    Button {
                        viewModel.toggleAllergy(allergy.id)
                    } label: {
                        SecondaryChip(
                            title: allergy.name,
                            isSelected: viewModel.isSelected(allergy.id),
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

    private func categoryIcon(for type: AllergyType) -> String {
        switch type {
        case .drug:  return "cross.case.fill"
        case .food:  return "fork.knife"
        case .other: return "leaf.fill"
        }
    }
}
