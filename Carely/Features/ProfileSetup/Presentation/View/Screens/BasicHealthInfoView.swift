//
//  BasicHealthInfoView.swift
//  Carely
//
//  Created by Mohamed Ayman on 19/07/2026.
//
import SwiftUI

struct BasicHealthInfoView: View {

    @StateObject private var viewModel: BasicHealthInfoViewModel
    
    init(viewModel: @autoclosure @escaping () -> BasicHealthInfoViewModel) {
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
            .padding(.top, Spacing.s16)
            .padding(.bottom, Spacing.s24)
        }
        .background(Color.backGround.ignoresSafeArea())
        .safeAreaInset(edge: .bottom) {
            HealthProfileBottomActionsView(
                isContinueDisabled: !viewModel.isFormValid,
                showBackButton: false,
                onBackTapped: viewModel.backTapped,
                onContinueTapped: viewModel.continueTapped
            )
        }
        .errorToast($viewModel.errorMessage)
    }
    
    private var measurementsSection: some View {
            HStack(alignment: .top, spacing: Spacing.s16) {
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
