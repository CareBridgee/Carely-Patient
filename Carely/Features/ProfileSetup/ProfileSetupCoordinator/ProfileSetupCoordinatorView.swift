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

    init(container: DIContainer,coordinator: ProfileSetupCoordinator, onFinish: @escaping () -> Void) {
        self.container = container
        self.onFinish = onFinish
        _coordinator = StateObject(wrappedValue: coordinator)
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {

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
                    BasicHealthInfoView(coordinator: coordinator, viewModel: container.makeBasicInfoHealthViewModel(existingData: coordinator.data.basicHealthInfo ))

                case .existingConditions:
                    ExistingConditionsView(coordinator: coordinator,viewModel: container.makeExistingConditionsViewModel(existingData: coordinator.data.existingConditions)
                                        )

                case .allergies:
                    AllergiesView(viewModel: AllergiesViewModel(coordinator: coordinator))

                case .currentMedication:

                    CurrentMedicationView(viewModel: CurrentMedicationViewModel(coordinator: coordinator))

                case .medicalHistory:
                 MedicalHistoryView(
                     viewModel: container.makeMedicalHistoryViewModel(coordinator: coordinator)
                                    )

                case .mobility:
                      MobilityView(
                        viewModel: container.makeMobilityViewModel(coordinator: coordinator)
                                    )

                case .emergencyContact:
             
                   EmergencyContactView(
                       viewModel: container.makeEmergencyContactViewModel(
                           initialContact: coordinator.data.emergencyContact,
                           onContinue: { contact in
                               coordinator.save(emergencyContact: contact)
                               withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                                   coordinator.next()
                               }
                           },
                           onBack: handleBack
                       )
                   )

                case .homeAddress:
                    HomeAddressView()
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
}
