//
//  ChoosePatientView.swift
//  Carely
//
//  Created by Mona Zarea on 24/07/2026.
//

import SwiftUI

struct ChoosePatientView: View {
    @StateObject var viewModel: ChoosePatientViewModel
    var onBackTapped: (() -> Void)? = nil
    
    var body: some View {
        ZStack {
            Color.backGround.ignoresSafeArea()

            if viewModel.isLoadingPatients && viewModel.patients.isEmpty {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.brandPrimary))
            } else if let loadError = viewModel.loadError, viewModel.patients.isEmpty {
                ErrorStateView(error: loadError) {
                    viewModel.retryLoadPatients()
                }
            } else {
                patientContent
            }
        }
        .safeAreaInset(edge: .bottom) {
            PrimaryButton(
                title: "Continue with Assessment",
                customIconSize: 18,
                icon: "arrow.right",
                iconPosition: .trailing,
                isLoading: viewModel.isLoading,
                action: viewModel.continueWithAssessment
            )
            .disabled(viewModel.selectedPatientId == nil)
            .padding(.horizontal, Spacing.s24)
            .padding(.vertical, Spacing.s16)
            .background(Color.backGround)
        }
        .task {
            await viewModel.onAppear()
        }
        .careConnectNavigationBar(
            title: "AI Assistant",
            showBackButton: true,
            onBackTapped: {
                onBackTapped?()
            }
        )
        .errorToast($viewModel.errorMessage)
    }

    private var patientContent: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: Spacing.s24) {
                // Titles
                VStack(alignment: .leading, spacing: Spacing.s8) {
                    Text("Choose Patient")
                        .carelyText(style: .heading3, weight: .semiBold)
                        .foregroundColor(.primaryFont)
                    
                    Text("Who are we assessing today? This helps us provide specific health recommendations.")
                        .carelyText(style: .bodySmall, weight: .regular)
                        .foregroundColor(.secondaryFont)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.top, Spacing.s16)
                
                // Patient List
                VStack(spacing: Spacing.s16) {
                    if viewModel.isLoading && viewModel.patients.isEmpty {
                        ForEach(0..<2, id: \.self) { _ in
                            HStack(spacing: Spacing.s16) {
                                EtmaenSkeletonCircle(size: 56)
                                VStack(alignment: .leading, spacing: Spacing.s8) {
                                    EtmaenSkeletonRect(width: 130, height: 16, radius: Radius.r8)
                                    EtmaenSkeletonRect(width: 60, height: 20, radius: 10)
                                }
                                Spacer()
                            }
                            .padding(Spacing.s16)
                            .background(Color.surface)
                            .cornerRadius(Spacing.s20)
                        }
                    } else {
                        ForEach(viewModel.patients) { patient in
                            PatientSelectionCard(
                                patient: patient,
                                isSelected: viewModel.selectedPatientId == patient.id,
                                action: {
                                    viewModel.selectPatient(patient)
                                }
                            )
                        }
                        
                        AddFamilyMemberCard(action: {
                            viewModel.onAddFamilyMember?()
                        })
                    }
                }
                
                // Info Box
                HStack(alignment: .top, spacing: Spacing.s12) {
                    Image(systemName: "info.circle")
                        .foregroundColor(.brandPrimary)
                    
                    Text("Adding family members allows you to manage their care plans, track medical appointments, and receive personalized health assessments tailored to their specific age and medical history.")
                        .carelyText(style: .caption, weight: .regular)
                        .foregroundColor(.secondaryFont)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(Spacing.s16)
                .background(Color.brandPrimary.opacity(0.1))
                .cornerRadius(Spacing.s16)
                
                Spacer(minLength: Spacing.s32)
            }
            .padding(.horizontal, Spacing.s24)
        }
    }
}
