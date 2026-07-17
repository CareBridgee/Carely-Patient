//
//  GenderSelectionView.swift
//  Carely
//
//  Created by Mona Zarea on 16/07/2026.
//


import SwiftUI

struct GenderSelectionView: View {
    @Binding var selectedGender: Gender
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text("Gender")
                .carelyText(style: .bodySmall, weight: .medium)
                .foregroundColor(Color.secondaryFont)
            
            HStack(spacing: 0) {
                GenderButton(title: "Male", genderValue: .male, selectedGender: $selectedGender)
                GenderButton(title: "Female", genderValue: .female, selectedGender: $selectedGender)
            }
            .background(Color.surfaceVariant)
            .cornerRadius(12)
        }
    }
}

struct GenderButton: View {
    let title: String
    let genderValue: Gender
    @Binding var selectedGender: Gender
    
    var body: some View {
        let isSelected = selectedGender == genderValue
        
        Button(action: {
            withAnimation { selectedGender = genderValue }
        }) {
            Text(title)
                .carelyText(style: .bodySmall, weight: isSelected ? .bold : .medium)
                .foregroundColor(isSelected ? Color.onPrimary : Color.secondaryFont)
                .frame(maxWidth: .infinity)
                .padding(.vertical, Spacing.sm)
                .background(isSelected ? Color.primary : Color.clear)
                .cornerRadius(12)
        }
    }
}
