//
//  PersonalInfoFormCard.swift
//  Carely
//
//  Created by Mona Zarea on 16/07/2026.
//
import SwiftUI
import PhotosUI

struct PersonalInfoFormCard: View {
    @ObservedObject var viewModel: PersonalInfoViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.s24) {
            Text("Personal Information")
                .carelyText(style: .heading3, weight: .regular)
                .padding(.bottom, Spacing.s2)

            photoPicker

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

            CustomDatePickerView(title: "Date of birth", selectedDate: $viewModel.dateOfBirth, errorMessage: viewModel.dobError)

            GenderSelectionView(selectedGender: $viewModel.gender)

            if let apiError = viewModel.apiErrorMessage {
                Text(apiError)
                    .carelyText(style: .caption)
                    .foregroundColor(Color.error)
                    .frame(maxWidth: .infinity, alignment: .center)
            }

            PrimaryButton(
                title: "Continue",
                customIconSize: IconSize.s16,
                icon: "arrow.right",
                iconPosition: .trailing,
                isLoading: viewModel.isLoading,
                action: { viewModel.continueTapped() }
            )
            .padding(.top, Spacing.s4)
        }
        .padding(Spacing.s20)
        .background(Color.surface)
        .cornerRadius(24)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }

    private var photoPicker: some View {
        let currentPhotoData = viewModel.profilePhotoData

        return VStack(spacing: Spacing.s12) {
            PhotosPicker(selection: $viewModel.photoSelection, matching: .images) {
                ZStack(alignment: .bottomTrailing) {
                    ZStack {
                        Circle().fill(Color.surfaceVariant).frame(width: 96, height: 96)
                        if let data = currentPhotoData, let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable().scaledToFill()
                                .frame(width: 96, height: 96)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "camera")
                                .font(.system(size: 28))
                                .foregroundColor(.hint)
                        }
                    }
                    .overlay(
                        Circle().strokeBorder(Color.brandPrimary.opacity(0.5), style: StrokeStyle(lineWidth: 1.5, dash: [6, 4]))
                    )
                    Circle()
                        .fill(Color.brandPrimary)
                        .frame(width: 28, height: 28)
                        .overlay(Image(systemName: "pencil").font(.system(size: 14, weight: .bold)).foregroundColor(.white))
                        .offset(x: -4, y: -4)
                }
            }
            Text("Upload Profile Photo")
                .carelyText(style: .bodySmall, weight: .bold)
                .foregroundColor(.brandPrimary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.s4)
    }
}
