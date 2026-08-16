//
//  ProfilePersonalInfoView.swift
//  Carely
//

import SwiftUI
import PhotosUI
@MainActor
struct ProfilePersonalInfoView: View {
    @StateObject private var viewModel: ProfilePersonalInfoViewModel

    init(viewModel: ProfilePersonalInfoViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            Color.backGround.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: Spacing.s20) {
                    // Form card
                    VStack(alignment: .leading, spacing: Spacing.s20) {
                        Text("Personal Info")
                            .carelyText(style: .heading2, weight: .bold)
                            .foregroundColor(.primaryFont)

                        photoPicker

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
                            placeholder: "e.g. Johnson",
                            text: $viewModel.lastName,
                            errorMessage: viewModel.lastNameError
                        )
                        CustomDatePickerView(
                            title: "Date of Birth",
                            selectedDate: $viewModel.dateOfBirth,
                            errorMessage: nil
                        )
                        GenderSelectionView(selectedGender: $viewModel.gender)

                        PrimaryButton(
                            title: "Save Changes",
                            icon: "checkmark",
                            iconPosition: .trailing,
                            isLoading: viewModel.isLoading,
                            isEnabled: viewModel.isFormValid,
                            action: viewModel.saveTapped
                        )
                    }
                    .padding(Spacing.s20)
                    .background(Color.surface)
                    .clipShape(RoundedRectangle.carely(Radius.r24))
                    .carelyShadow(.sm)
                }
                .padding(Spacing.s16)
                .padding(.bottom, Spacing.s32)
            }
        }
        .careConnectNavigationBar(
            title: "Personal Info",
            showBackButton: true,
            onBackTapped: {
                viewModel.backTapped()
            }
        )
        .blur(radius: viewModel.isLoading ? 3 : 0)

        .navigationBarHidden(true)
        .onChange(of: viewModel.isSaved) {
            if viewModel.isSaved {
                viewModel.backTapped()
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
        .errorToast($viewModel.errorMessage)
    }

    // MARK: - Photo Picker
    private var photoPicker: some View {
        ProfilePhotoPickerView(
            photoSelection: $viewModel.photoSelection,
            selectedImage: viewModel.selectedImage,
            existingImageUrl: viewModel.existingImageUrl
        )
    }
}

// MARK: - ProfilePhotoPickerView

private struct ProfilePhotoPickerView: View {
    @Binding var photoSelection: PhotosPickerItem?
    let selectedImage: UIImage?
    let existingImageUrl: URL?

    var body: some View {
        VStack(spacing: Spacing.s12) {
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
                        } else if let existingImageUrl {
                            AsyncImage(url: existingImageUrl) { phase in
                                if let img = phase.image {
                                    img.resizable().scaledToFill()
                                } else if phase.error != nil {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 36))
                                        .foregroundColor(.hint)
                                } else {
                                    ProgressView()
                                        .tint(.brandPrimary)
                                }
                            }
                            .frame(width: 96, height: 96)
                            .clipShape(Circle())
                        } else {
                            Image(systemName: "camera")
                                .font(.system(size: 28))
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
                            Image(systemName: "pencil")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Color.onPrimary)
                        )
                        .offset(x: -4, y: -4)
                }
            }

            Text("Change Photo")
                .carelyText(style: .bodySmall, weight: .bold)
                .foregroundColor(.brandPrimary)
        }
        .frame(maxWidth: .infinity)
    }
}
