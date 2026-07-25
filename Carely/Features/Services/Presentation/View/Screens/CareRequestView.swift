//
//  CareRequestView.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 22/07/2026.
//

import SwiftUI

struct CareRequestView: View {
    @StateObject var viewModel: CareRequestViewModel
    let onEditProfileTapped: () -> Void

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: Spacing.s20) {
                if viewModel.showsFillWithAI {
                    fillWithAIButton
                }

                patientSection

                ChosenServiceRow(
                    service: viewModel.selectedService,
                    allServices: viewModel.availableServices,
                    onSelect: { viewModel.selectedService = $0 }
                )

                SymptomsTextArea(
                    text: $viewModel.description,
                    errorMessage: viewModel.descriptionError,
                    onFillWithAI: viewModel.fillWithAI
                )

                AddressPreviewCard(
                    address: viewModel.address,
                    onEditOrAddTapped: { /* wire to address editing destination */ },
                    errorMessage: viewModel.addressError
                )

                paymentSection
            }
            .padding(.horizontal, Spacing.s16)
            .padding(.top, Spacing.s16)
            .padding(.bottom, Spacing.s16)
            
            
        }
        .safeAreaInset(edge: .bottom) {
            PrimaryButton(
                title: "Submit Request",
                isLoading: viewModel.isSubmitting,
                action: viewModel.submitTapped
            )
            .padding(.horizontal, Spacing.s16)
            .padding(.vertical, Spacing.s12)
            .background(Color.backGround)
        }
        .background(Color.backGround.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
        .safeAreaInset(edge: .top) {
            AppHeader(title: "Care Request", trailingIcon: "questionmark")
                .padding(.horizontal, Spacing.s16)
                .background(Color.backGround)
        }
        .task { await viewModel.onAppear() }
        
        Spacer(minLength: Spacing.s56)
    }

    private var fillWithAIButton: some View {
        Button(action: viewModel.fillWithAI) {
            Label("Fill with AI", systemImage: "sparkles")
                .carelyText(style: .bodySmall, weight: .semiBold)
                .foregroundColor(.brandPrimary)
                .padding(.horizontal, Spacing.s16)
                .padding(.vertical, Spacing.s8)
                .overlay(Capsule().stroke(Color.brandPrimary, lineWidth: 1))
        }
        
    }

    private var patientSection: some View {
        HStack {
            PatientSelectorRow(
                selected: viewModel.selectedPatient,
                onSelect: { viewModel.selectedPatient = $0 },
                onAddTapped: {}
            )

            Spacer()

            Button(action: onEditProfileTapped) {
                Text("Edit Profile")
                    .carelyText(style: .bodySmall, weight: .semiBold)
                    .foregroundColor(.brandPrimary)
            }
        }
    }

    private var paymentSection: some View {
        VStack(alignment: .leading, spacing: Spacing.s12) {
            Text("Select Payment Method")
                .carelyText(style: .bodyRegular, weight: .semiBold)
                .foregroundColor(.primaryFont)

            ForEach(PaymentMethod.allCases) { method in
                PaymentMethodRow(
                    method: method,
                    isSelected: viewModel.selectedPaymentMethod == method,
                    onSelect: { viewModel.selectedPaymentMethod = method }
                )
            }

            if let errorMessage = viewModel.paymentMethodError {
                Text(errorMessage)
                    .carelyText(style: .caption, weight: .medium)
                    .foregroundColor(.error)
            }
        }
    }
}


