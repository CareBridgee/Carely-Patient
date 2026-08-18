//
//  AddFamilyMemberInfoView.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 01/08/2026.
//

import SwiftUI
import PhotosUI

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

                    photoPicker

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
                            isRequired: true,
                            placeholder: "e.g. Sarah",
                            text: $viewModel.firstName,
                            errorMessage: viewModel.firstNameError
                        )
                        CarelyTextField(
                            label: "Last Name",
                            isRequired: true,
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
                        AlertBanner(style: .error, message: apiError)
                            .animation(CarelyMotion.springDefault, value: viewModel.apiErrorMessage)
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
            .careConnectNavigationBar(
                title: "Add Family Member",
                showBackButton: true,
                onBackTapped: { viewModel.backTapped() }
            )
            .safeAreaInset(edge: .bottom) {
                HealthProfileBottomActionsView(
                    showBackButton: true,
                    onBackTapped: viewModel.backTapped,
                    onContinueTapped: viewModel.continueTapped
                )
            }
        }
        .etmaenLoadingOverlay(isPresented: viewModel.isLoading, message: "Please wait...")
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.apiErrorMessage ?? "Something went wrong.")
        }
        .animation(.easeInOut(duration: 0.3), value: viewModel.isLoading)
    }

    // MARK: - Photo Picker

    private var photoPicker: some View {
        FamilyMemberPhotoPickerView(
            photoSelection: $viewModel.photoSelection,
            selectedImage: viewModel.selectedImage
        )
    }
}

// MARK: - FamilyMemberPhotoPickerView

private struct FamilyMemberPhotoPickerView: View {
    @Binding var photoSelection: PhotosPickerItem?
    let selectedImage: UIImage?

    var body: some View {
        HStack {
            Spacer()
            VStack(spacing: Spacing.s8) {
                PhotosPicker(selection: $photoSelection, matching: .images) {
                    ZStack(alignment: .bottomTrailing) {
                        ZStack {
                            Circle()
                                .fill(Color.surfaceVariant)
                                .frame(width: 96, height: 96)

                            if let selectedImage {
                                Image(uiImage: selectedImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 96, height: 96)
                                    .clipShape(Circle())
                            } else {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 36))
                                    .foregroundColor(.hint)
                            }
                        }
                        .overlay(
                            Circle()
                                .strokeBorder(
                                    Color.brandPrimary.opacity(0.5),
                                    style: StrokeStyle(lineWidth: 1.5, dash: [6, 4])
                                )
                        )

                        Circle()
                            .fill(Color.brandPrimary)
                            .frame(width: 28, height: 28)
                            .overlay(
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(Color.onPrimary)
                            )
                            .offset(x: -4, y: -4)
                    }
                }
                .buttonStyle(.plain)

                Text("Add Photo")
                    .carelyText(style: .bodySmall, weight: .bold)
                    .foregroundColor(.brandPrimary)
            }
            Spacer()
        }
    }
}
