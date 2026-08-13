//
//  CurrentMedicationView.swift
//  Carely
//

import SwiftUI
import PhotosUI

struct CurrentMedicationView: View {

    @StateObject private var viewModel: CurrentMedicationViewModel
    @State private var selectedPhotoItem: PhotosPickerItem?

    init(viewModel: CurrentMedicationViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: Spacing.s24) {

                    ProfileSetupHeaderView(
                        title: "Current Medications",
                        subtitle: "Please list all medications you are currently taking, including dosage and frequency if possible."
                    )

                    noCurrentMedicationsToggle

                    if viewModel.isLoading {
                        VStack(spacing: Spacing.s12) {
                            ProgressView()
                            Text("Loading medications...")
                                .carelyText(style: .bodyRegular, weight: .medium)
                                .foregroundColor(.secondaryFont)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, Spacing.s32)
                    } else {
                        VStack(spacing: Spacing.s12) {
                            ForEach(Array(viewModel.medications.enumerated()), id: \.offset) { index, medication in
                                medicationRow(index: index, medication: medication)
                            }

                            addMedicationButton
                        }
                        .disabled(viewModel.hasNoCurrentMedications)
                        .opacity(viewModel.hasNoCurrentMedications ? 0.4 : 1)

                        prescriptionPhotoUpload
                            .disabled(viewModel.hasNoCurrentMedications)
                            .opacity(viewModel.hasNoCurrentMedications ? 0.4 : 1)
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
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "An error occurred.")
        }
        .safeAreaInset(edge: .bottom) {
            HealthProfileBottomActionsView(
                onBackTapped: viewModel.backTapped,
                onContinueTapped: viewModel.continueTapped
            )
        }
    }

    private var noCurrentMedicationsToggle: some View {
        HStack(spacing: Spacing.s12) {
            VStack(alignment: .leading, spacing: Spacing.s2) {
                Text("No current medications")
                    .carelyText(style: .bodyRegular, weight: .semiBold)
                    .foregroundColor(.primaryFont)

                Text("I am not taking any prescribed drugs")
                    .carelyText(style: .bodySmall)
                    .foregroundColor(.secondaryFont)
            }

            Spacer(minLength: Spacing.s8)

            Toggle("", isOn: Binding(
                get: { viewModel.hasNoCurrentMedications },
                set: { _ in viewModel.toggleNoCurrentMedications() }
            ))
            .labelsHidden()
            .tint(.success)
        }
        .padding(Spacing.s16)
        .background(Color.surface)
        .clipShape(RoundedRectangle.carely(Radius.r16))
        .overlay(
            RoundedRectangle.carely(Radius.r16)
                .stroke(viewModel.hasNoCurrentMedications ? Color.success : Color.divider, lineWidth: 1)
        )
    }

    private func medicationRow(index: Int, medication: PatientMedication) -> some View {
        HStack(spacing: Spacing.s8) {
            CarelyTextField(
                placeholder: "Medication name (e.g. Lisinopril 10mg)",
                text: $viewModel.medications[index].name
            )

            if viewModel.medications.count > 1 {
                Button {
                    viewModel.removeMedication(medication)
                } label: {
                    Image(systemName: "trash")
                        .resizable()
                        .scaledToFit()
                        .frame(width: IconSize.s16, height: IconSize.s16)
                        .foregroundColor(.error)
                        .frame(width: Spacing.s48, height: Spacing.s48)
                        .background(Color.errorContainer.opacity(0.5))
                        .clipShape(RoundedRectangle.carely(Radius.r12))
                }
            }
        }
    }

    private var addMedicationButton: some View {
        Button(action: viewModel.addMedicationTapped) {
            HStack(spacing: Spacing.s8) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: IconSize.s20, height: IconSize.s20)

                Text("Add Medication")
                    .carelyText(style: .bodyRegular, weight: .semiBold)
            }
            .foregroundColor(.brandPrimary)
            .frame(maxWidth: .infinity)
            .frame(height: Spacing.s48)
            .overlay(
                RoundedRectangle.carely(Radius.r12)
                    .strokeBorder(style: StrokeStyle(lineWidth: 1.5, dash: [6, 4]))
                    .foregroundColor(.brandPrimary)
            )
        }
        .buttonStyle(.plain)
    }

    private var prescriptionPhotoUpload: some View {
        PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
            ZStack(alignment: .topTrailing) {
                if let data = viewModel.prescriptionPhotoData,
                   let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .frame(height: 140)
                        .clipShape(RoundedRectangle.carely(Radius.r16))
                        .clipped()

                    Button {
                        selectedPhotoItem = nil
                        viewModel.prescriptionPhotoPicked(nil)
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: IconSize.s24, height: IconSize.s24)
                            .foregroundColor(.white)
                            .background(Circle().fill(Color.black.opacity(0.4)))
                    }
                    .padding(Spacing.s8)
                } else {
                    VStack(spacing: Spacing.s8) {
                        Image(systemName: "photo.on.rectangle.angled")
                            .resizable()
                            .scaledToFit()
                            .frame(width: IconSize.s28, height: IconSize.s28)
                            .foregroundColor(.brandPrimary.opacity(0.6))

                        Text("Add a photo of your prescription")
                            .carelyText(style: .bodySmall, weight: .medium)
                            .foregroundColor(.secondaryFont)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 140)
                    .background(Color.primaryContainer.opacity(0.5))
                    .clipShape(RoundedRectangle.carely(Radius.r16))
                }
            }
        }
        .buttonStyle(.plain)
        .onChange(of: selectedPhotoItem) { _, newItem in
            guard let newItem else { return }
            Task {
                if let data = try? await newItem.loadTransferable(type: Data.self) {
                    viewModel.prescriptionPhotoPicked(data)
                }
            }
        }
    }
}
