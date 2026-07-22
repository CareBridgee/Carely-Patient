//
//  BasicHealthInfoView.swift
//  Carely
//
//  Created by Mohamed Ayman on 19/07/2026.
//

import SwiftUI

struct BasicHealthInfoView: View {

    let coordinator: ProfileSetupCoordinator
    @StateObject private var viewModel : BasicHealthInfoViewModel
    
    init(coordinator: ProfileSetupCoordinator, viewModel: @autoclosure @escaping () -> BasicHealthInfoViewModel ) {
        self.coordinator = coordinator
        _viewModel = StateObject(wrappedValue: viewModel())
    }
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: Spacing.s24) {
                
                HealthInfoCardView()
                
                measurementsSection
                
                BloodTypeSelectionCardView(selectedType: $viewModel.bloodType)
            }
            .padding(.horizontal, Spacing.s20)
            .padding(.bottom, Spacing.s24)
        }
        .background(Color.backGround.ignoresSafeArea())
        .navigationBarHidden(true)
        .safeAreaInset(edge: .bottom) {
            HealthProfileBottomActionsView(
                isContinueDisabled: !viewModel.isFormValid,
                onBackTapped: {
                    coordinator.save(basicHealthInfo: viewModel.basicHealthInfo)
                    coordinator.previous()
                },
                onContinueTapped: {
                    coordinator.save(basicHealthInfo: viewModel.basicHealthInfo)
                    coordinator.next()
                }
            )
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    
    private var measurementsSection: some View {
        HStack(spacing: Spacing.s16) {
            MeasurementInputCardView(
                title: "Height",
                placeholder: "170",
                unit: "cm",
                value: $viewModel.heightText,
                errorMessage: viewModel.heightError
            )
            
            MeasurementInputCardView(
                title: "Weight",
                placeholder: "65",
                unit: "kg",
                value: $viewModel.weightText,
                errorMessage: viewModel.weightError
            )
        }
    }
}

struct BasicHealthInfoView_Previews: PreviewProvider {
    static var previews: some View {
        BasicHealthInfoView(coordinator: ProfileSetupCoordinator(data: ProfileSetupData()), viewModel: BasicHealthInfoViewModel(existingData: BasicHealthInfo(height: 170.0, weight: 65.0, bloodType: "A+")))
    }
}
