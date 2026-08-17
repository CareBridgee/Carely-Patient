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
    let onAddFamilyMemberTapped: () -> Void
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
                    errorMessage: viewModel.displayedDescriptionError,
                    onFillWithAI: viewModel.fillWithAI
                )
                AddressPreviewCard(
                    address: viewModel.address,
                    onEditOrAddTapped: { viewModel.addOrEditAddressTapped() },
                    errorMessage: viewModel.addressError
                )
                paymentMethodSection
                
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
        .careConnectNavigationBar(title: "Care Request")
        .task { await viewModel.onAppear() }
        .errorToast($viewModel.submissionErrorMessage)
        .sheet(isPresented: Binding(
            get: { viewModel.addressSheetViewModel != nil },
            set: { isPresented in if !isPresented { viewModel.dismissAddressSheet() } }
        )) {
            if let sheetViewModel = viewModel.addressSheetViewModel {
                HomeAddressView(viewModel: sheetViewModel)
                    .presentationDetents([.fraction(0.9), .large])
                    .presentationDragIndicator(.visible)
            }
        }
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
    private var paymentMethodSection: some View {
            VStack(alignment: .leading, spacing: Spacing.s8) {
                Text("Select Payment Method")
                    .carelyText(style: .heading3, weight: .bold)
                    .foregroundColor(.primaryFont)
                    .padding(.top, Spacing.s8)

                VStack(spacing: Spacing.s12) {
                    ForEach(PaymentMethod.allCases) { method in
                        PaymentMethodRow(
                            method: method,
                            isSelected: viewModel.selectedPaymentMethod == method,
                            onSelect: { viewModel.selectedPaymentMethod = method }
                        )
                    }
                }
            }
        }
    
    private var patientSection: some View {
        VStack(alignment: .leading, spacing: Spacing.s8) {
            Button(action: onEditProfileTapped) {
                Text("Edit Profile")
                    .carelyText(style: .bodySmall, weight: .semiBold)
                    .foregroundColor(.brandPrimary)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                PatientSelectorRow(
                    patients: viewModel.patients,
                    selected: viewModel.selectedPatient,
                    onSelect: { viewModel.selectPatient($0) },
                    onAddTapped: onAddFamilyMemberTapped
                )
            }
        }
    }
}
