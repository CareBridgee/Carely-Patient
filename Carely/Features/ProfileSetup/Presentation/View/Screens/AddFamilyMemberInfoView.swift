//
//  AddFamilyMemberInfoView.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 01/08/2026.
//


import SwiftUI

struct AddFamilyMemberInfoView: View {
    @StateObject private var viewModel: AddFamilyMemberInfoViewModel

    init(viewModel: @autoclosure @escaping () -> AddFamilyMemberInfoViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel())
    }

    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: Spacing.s24) {
                    Text("Family Member Info")
                        .carelyText(style: .heading3, weight: .regular)

                    CarelyTextField(
                        label: "Relationship",
                        isRequired: true,
                        placeholder: "e.g. Mother, Father, Spouse",
                        text: $viewModel.relationship,
                        errorMessage: viewModel.relationshipError
                    )

                    HStack(spacing: Spacing.s12) {
                        CarelyTextField(
                            label: "First Name",
                            isRequired: false,
                            placeholder: "e.g. Sarah",
                            text: $viewModel.firstName,
                            errorMessage: viewModel.firstNameError
                        )
                        CarelyTextField(
                            label: "Last Name",
                            isRequired: false,
                            placeholder: "e.g. Jenkins",
                            text: $viewModel.lastName,
                            errorMessage: viewModel.lastNameError
                        )
                    }

                    CustomDatePickerView(
                        title: "Date of birth",
                        selectedDate: $viewModel.dateOfBirth,
                        errorMessage: viewModel.dobError
                    )

                    GenderSelectionView(selectedGender: $viewModel.gender)

                    if let apiError = viewModel.apiErrorMessage {
                        Text(apiError)
                            .carelyText(style: .caption)
                            .foregroundColor(Color.error)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                .padding(Spacing.s20)
                .background(Color.surface)
                .cornerRadius(24)
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                .padding(.horizontal, Spacing.s16)
                .padding(.top, Spacing.s24)
            }
            .background(Color.backGround.ignoresSafeArea())
            .navigationBarHidden(true)
            .safeAreaInset(edge: .bottom) {
                HealthProfileBottomActionsView(
                    showBackButton: true,
                    onBackTapped: viewModel.backTapped,
                    onContinueTapped: viewModel.continueTapped
                )
            }
            .blur(radius: viewModel.isLoading ? 3 : 0)

            if viewModel.isLoading {
                ZStack {
                    Color.black.opacity(0.3).ignoresSafeArea()
                    VStack(spacing: 16) {
                        ProgressView().scaleEffect(1.5).tint(.brandPrimary)
                        Text("Please wait...")
                            .carelyText(style: .bodyRegular, weight: .bold)
                            .foregroundColor(.primaryFont)
                    }
                    .padding(32)
                    .background(Color.surface)
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
                }
                .zIndex(1)
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }
        }
        .animation(.easeInOut(duration: 0.3), value: viewModel.isLoading)
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.apiErrorMessage ?? "Something went wrong.")
        }
    }
}