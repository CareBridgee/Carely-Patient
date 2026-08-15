//
//  ProfileSetupCoordinatorView.swift
//  Carely
//
//  Created by Mohamed Ayman on 19/07/2026.
//

import SwiftUI


struct ProfileSetupCoordinatorView: View {
    

    // MARK: - Coordinator

    @StateObject private var coordinator: ProfileSetupCoordinator
    private let container : DIContainer
    private let onFinish: () -> Void

    // MARK: - Init


    init(coordinator: ProfileSetupCoordinator,container: DIContainer, onFinish: @escaping () -> Void) {
        self.onFinish = onFinish
        _coordinator = StateObject(wrappedValue: coordinator)
        self.container = container
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: onFinish) {
                    HStack(spacing: Spacing.s4) {
                        Image(systemName: "chevron.left")
                        Text("Profile")
                    }
                    .carelyText(style: .bodyRegular, weight: .semiBold)
                    .foregroundColor(.brandPrimary)
                }
                Spacer()
            }
            .padding(.horizontal, Spacing.s16)
            .padding(.top, Spacing.s8)

            StepProgressHeader(
                currentStep: coordinator.currentStepIndex,
                totalSteps: coordinator.totalSteps,
                stepTitle: coordinator.currentStep.stepTitle
            )
            .padding(.top, Spacing.s12)
            .padding(.horizontal, Spacing.s16)
            if coordinator.isLoadingData {
                profileSetupSkeletonView
            } else {
                Group {
                    switch coordinator.currentStep {
                    case .basicHealthInfo:
                        BasicHealthInfoView(viewModel: makeBasicHealthInfoViewModel())

                case .existingConditions:
                    ExistingConditionsView(
                        coordinator: coordinator,
                        viewModel: container.makeExistingConditionsViewModel(
                            existingData: coordinator.data.existingConditions,
                            overrideProfileId: coordinator.profileId,
                            coordinator: coordinator
                        )
                    )

                case .allergies:
                    AllergiesView(
                        viewModel: container.makeAllergiesViewModel(
                            coordinator: coordinator,
                            overrideProfileId: coordinator.profileId
                        )
                    )

                case .currentMedication:
                    CurrentMedicationView(
                        viewModel: container.makeCurrentMedicationViewModel(
                            coordinator: coordinator,
                            overrideProfileId: coordinator.profileId
                        )
                    )

                case .medicalHistory:
                    MedicalHistoryView(
                        viewModel: container.makeMedicalHistoryViewModel(
                            existingData: coordinator.data.medicalHistory,
                            overrideProfileId: coordinator.profileId,
                            coordinator: coordinator
                        )
                    )

                case .mobility:
                    MobilityView(
                        viewModel: container.makeMobilityViewModel(
                            existingData: coordinator.data.mobility,
                            overrideProfileId: coordinator.profileId,
                            coordinator: coordinator
                        )
                    )

                case .emergencyContact:
                    EmergencyContactView(
                        viewModel: container.makeEmergencyContactViewModel(
                            initialContact: coordinator.data.emergencyContact,
                            overrideProfileId: coordinator.profileId,
                            coordinator: coordinator,
                            onFinish: onFinish
                        )
                    )

                case .homeAddress:
                    HomeAddressView(
                        viewModel: container.makeHomeAddressViewModel(
                            initialAddress: coordinator.data.homeAddress,
                            overrideProfileId: coordinator.profileId,
                            coordinator: coordinator,
                            onFinishSetup: onFinish
                        )
                    )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .transition(
                .asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                )
            )
            .animation(.spring(response: 0.4, dampingFraction: 0.85), value: coordinator.currentStep)
        }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.backGround.ignoresSafeArea())
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            Task {
                await coordinator.loadExistingProfileData(networkService: container.makeProfileNetworkService())
            }
        }
    }

    // MARK: - Helpers

    private func handleBack() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
            coordinator.previous()
        }
    }
    private func makeBasicHealthInfoViewModel() -> BasicHealthInfoViewModel {
        if let profileId = coordinator.profileId {
            return container.makeBasicInfoHealthViewModel(
                existingData: coordinator.data.basicHealthInfo,
                profileId: profileId,
                coordinator: coordinator
            )
        }
        return container.makeBasicInfoHealthViewModel(
            existingData: coordinator.data.basicHealthInfo,
            coordinator: coordinator
        )
    }

    private var profileSetupSkeletonView: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: Spacing.s24) {
                // Header Info Card Skeleton
                VStack(alignment: .leading, spacing: Spacing.s12) {
                    EtmaenSkeletonRect(width: 140, height: 18, radius: Radius.r8)
                    EtmaenSkeletonRect(height: 14, radius: Radius.r8)
                    EtmaenSkeletonRect(width: 220, height: 14, radius: Radius.r8)
                }
                .padding(Spacing.s20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.surface)
                .clipShape(RoundedRectangle.carely(Radius.r24))
                .carelyShadow(.sm)

                // Height & Weight Inputs Skeleton
                HStack(alignment: .top, spacing: Spacing.s16) {
                    ForEach(0..<2, id: \.self) { _ in
                        VStack(alignment: .leading, spacing: Spacing.s12) {
                            EtmaenSkeletonRect(width: 70, height: 14, radius: Radius.r8)
                            EtmaenSkeletonRect(height: 48, radius: Radius.r12)
                        }
                        .padding(Spacing.s16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.surface)
                        .clipShape(RoundedRectangle.carely(Radius.r20))
                        .carelyShadow(.sm)
                    }
                }

                // Blood Type Card Skeleton
                VStack(alignment: .leading, spacing: Spacing.s16) {
                    EtmaenSkeletonRect(width: 100, height: 16, radius: Radius.r8)
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: Spacing.s12), count: 4), spacing: Spacing.s12) {
                        ForEach(0..<8, id: \.self) { _ in
                            EtmaenSkeletonRect(height: 44, radius: Radius.r12)
                        }
                    }
                }
                .padding(Spacing.s20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.surface)
                .clipShape(RoundedRectangle.carely(Radius.r24))
                .carelyShadow(.sm)
            }
            .padding(.horizontal, Spacing.s20)
            .padding(.top, Spacing.s16)
            .padding(.bottom, Spacing.s24)
        }
    }
}

#Preview {
    let container = DIContainer()
    return ProfileSetupCoordinatorView(
        coordinator: container.makeProfileSetupCoordinator(),
        container: container,
        onFinish: {}
    )
}
