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
       //     AppHeader(title: "CareConnect",showBackButton: false)
            StepProgressHeader(
                currentStep: coordinator.currentStepIndex,
                totalSteps: ProfileSetupStep.allCases.count,
                stepTitle: coordinator.currentStep.stepTitle
            )
            .padding(.top, Spacing.s16)
            .padding(.horizontal, Spacing.s16)
            .padding(.bottom, Spacing.s24)
            Group {
                switch coordinator.currentStep {
                case .basicHealthInfo:
                    BasicHealthInfoView(viewModel: makeBasicHealthInfoViewModel())

                case .existingConditions:
                    ExistingConditionsView(coordinator: coordinator,viewModel: container.makeExistingConditionsViewModel(existingData: coordinator.data.existingConditions)
                                        )

                case .allergies:
                    AllergiesView(viewModel: AllergiesViewModel(coordinator: coordinator))

                case .currentMedication:

                    CurrentMedicationView(viewModel: CurrentMedicationViewModel(coordinator: coordinator))

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
                            coordinator: coordinator
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
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.backGround.ignoresSafeArea())
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
}

#Preview {
    let container = DIContainer()
    return ProfileSetupCoordinatorView(
        coordinator: container.makeProfileSetupCoordinator(),
        container: container,
        onFinish: {}
    )
}
