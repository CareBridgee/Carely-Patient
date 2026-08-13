//
//  ProfileHealthView.swift
//  Carely
//

import SwiftUI

struct ProfileHealthView: View {
    @StateObject private var viewModel: ProfileHealthViewModel

    init(viewModel: ProfileHealthViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            Color.backGround.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: Spacing.s24) {
                    topBar
                    header
                    formCard
                }
                .padding(Spacing.s16)
                .padding(.bottom, Spacing.s32)
            }
        }
        .navigationBarHidden(true)
        .alert("Something went wrong", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "Please try again.")
        }
        .onChange(of: viewModel.isSaved) { saved in
            if saved { viewModel.backTapped() }
        }
    }

    // MARK: - Top Bar

    private var topBar: some View {
        HStack {
            Button(action: viewModel.backTapped) {
                Image(systemName: "arrow.left")
                    .carelyText(style: .bodyLarge, weight: .semiBold)
                    .foregroundColor(.brandPrimary)
                    .frame(width: 40, height: 40)
                    .background(Color.surface)
                    .clipShape(Circle())
            }
            Spacer()
            Text("Health Profile")
                .carelyText(style: .heading3, weight: .semiBold)
                .foregroundColor(.brandPrimary)
            Spacer()
            Color.clear.frame(width: 40, height: 40)
        }
    }

    // MARK: - Header

    private var header: some View {
        VStack(alignment: .leading, spacing: Spacing.s4) {
            Text("Health Profile")
                .carelyText(style: .heading2, weight: .bold)
                .foregroundColor(.primaryFont)
            Text("Update your medical metrics and mobility information.")
                .carelyText(style: .bodySmall)
                .foregroundColor(.secondaryFont)
        }
    }

    // MARK: - Form Card

    private var formCard: some View {
        VStack(alignment: .leading, spacing: Spacing.s20) {

            // Blood Type Picker
            sectionLabel("Blood Type")
            Picker("Blood Type", selection: $viewModel.bloodType) {
                ForEach(ProfileHealthViewModel.bloodTypes, id: \.self) { bt in
                    Text(bt.isEmpty ? "— Not Set —" : bt).tag(bt)
                }
            }
            .pickerStyle(.menu)
            .tint(.brandPrimary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(Spacing.s12)
            .background(Color.backGround)
            .clipShape(RoundedRectangle.carely(Radius.r12))

            // Height
            CarelyTextField(
                label: "Height (cm)",
                isRequired: false,
                placeholder: "e.g. 170",
                text: $viewModel.heightText,
                errorMessage: viewModel.heightError
            )

            // Weight
            CarelyTextField(
                label: "Weight (kg)",
                isRequired: false,
                placeholder: "e.g. 70",
                text: $viewModel.weightText,
                errorMessage: viewModel.weightError
            )

            // Mobility Status Picker
            sectionLabel("Mobility Status")
            Picker("Mobility Status", selection: $viewModel.mobilityStatus) {
                ForEach(ProfileHealthViewModel.mobilityOptions, id: \.value) { opt in
                    Text(opt.label).tag(opt.value)
                }
            }
            .pickerStyle(.menu)
            .tint(.brandPrimary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(Spacing.s12)
            .background(Color.backGround)
            .clipShape(RoundedRectangle.carely(Radius.r12))

            // Mobility Notes
            CarelyTextField(
                label: "Mobility Notes",
                isRequired: false,
                placeholder: "Any additional notes...",
                text: $viewModel.mobilityNotes,
                errorMessage: nil
            )

            // Previous Surgeries
            CarelyTextField(
                label: "Previous Surgeries",
                isRequired: false,
                placeholder: "e.g. Appendectomy 2018",
                text: $viewModel.previousSurgeries,
                errorMessage: nil
            )

            // Previous Hospitalizations
            CarelyTextField(
                label: "Previous Hospitalizations",
                isRequired: false,
                placeholder: "e.g. Cardiac care 2020",
                text: $viewModel.previousHospitalizations,
                errorMessage: nil
            )

            if let err = viewModel.errorMessage {
                Text(err)
                    .carelyText(style: .caption)
                    .foregroundColor(.error)
                    .frame(maxWidth: .infinity, alignment: .center)
            }

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

    private func sectionLabel(_ text: String) -> some View {
        Text(text)
            .carelyText(style: .bodySmall, weight: .semiBold)
            .foregroundColor(.secondaryFont)
    }
}
