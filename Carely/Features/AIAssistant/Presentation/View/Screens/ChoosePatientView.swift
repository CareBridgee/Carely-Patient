//
//  ChoosePatientView.swift
//  Carely
//
//  Created by Mona Zarea on 24/07/2026.
//

import SwiftUI

struct ChoosePatientView: View {
    @StateObject var viewModel: ChoosePatientViewModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: Spacing.s24) {
                // Header Profile
                HStack(spacing: Spacing.s12) {
                    Circle()
                        .fill(Color.brandPrimary.opacity(0.2))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: "person.fill")
                                .foregroundColor(.brandPrimary)
                        )
                    
                    Text("Good morning, Elena")
                        .carelyText(style: .bodyRegular, weight: .medium)
                        .foregroundColor(.brandPrimary)
                    
                    Spacer()
                }
                .padding(.top, Spacing.s16)
                
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
                
                // Patient List
                VStack(spacing: Spacing.s16) {
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
                        // Action for adding family member
                    })
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
        .background(Color.backGround.ignoresSafeArea())
        .safeAreaInset(edge: .bottom) {
            PrimaryButton(
                title: "Continue with Assessment",
                customIconSize: 18,
                icon: "arrow.right",
                iconPosition: .trailing,
                isLoading: false,
                action: viewModel.continueWithAssessment
            )
            .padding(.horizontal, Spacing.s24)
            .padding(.vertical, Spacing.s16)
            .background(Color.backGround)
        }
        .task {
            await viewModel.onAppear()
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    let mockRepo = MockAIPatientRepository()
    let useCase = GetAIPatientsUseCase(repository: mockRepo)
    let viewModel = ChoosePatientViewModel(
        getAIPatientsUseCase: useCase,
        onShowPatientDetails: { _ in },
        onContinueWithAssessment: { _ in }
    )
    
    return ChoosePatientView(viewModel: viewModel)
}
