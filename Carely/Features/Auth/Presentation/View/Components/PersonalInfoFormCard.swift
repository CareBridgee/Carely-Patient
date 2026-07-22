//
//  PersonalInfoFormCard.swift
//  Carely
//
//  Created by Mona Zarea on 16/07/2026.
//

import SwiftUI

struct PersonalInfoFormCard: View {
    @ObservedObject var viewModel: PersonalInfoViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.s24) {
            Text("Personal Information")
                .carelyText(style: .heading3, weight: .regular)
                .padding(.bottom, Spacing.s2)
            
            HStack(spacing: Spacing.s12) {
                CarelyTextField(label: "First name", placeholder: "Jane", text: $viewModel.firstName, errorMessage: viewModel.firstNameError)
                CarelyTextField(label: "Last name", placeholder: "Doe", text: $viewModel.lastName, errorMessage: viewModel.lastNameError)
            }
            
            CustomDatePickerView(title: "Date of birth", selectedDate: $viewModel.dateOfBirth, errorMessage: viewModel.dobError)
            
            GenderSelectionView(selectedGender: $viewModel.gender)
            
            if let apiError = viewModel.apiErrorMessage{
                Text(apiError)
                    .carelyText(style: .caption)
                    .foregroundColor(Color.error)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            
            PrimaryButton(
                title: "Continue",
                customIconSize: IconSize.s16,
                icon: "arrow.right",
                iconPosition: .trailing,
                isLoading: viewModel.isLoading,
                action: {
                    viewModel.continueTapped()
                }
            )
            .padding(.top, Spacing.s4)        }
        .padding(Spacing.s20)
        .background(Color.surface)
        .cornerRadius(24)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
}
