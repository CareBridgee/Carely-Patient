//
//  PatientSelectionCard.swift
//  Carely
//
//  Created by AI Assistant
//

import SwiftUI

struct PatientSelectionCard: View {
    let patient: AIPatient
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.s16) {
                // Avatar
                ZStack(alignment: .bottomTrailing) {
                    ZStack {
                        Circle()
                            .fill(Color.brandPrimary.opacity(0.15))
                            .frame(width: 56, height: 56)
                            .overlay(
                                Circle().stroke(isSelected ? Color.brandPrimary : Color.clear, lineWidth: 2)
                            )
                        
                        Image(systemName: "person.fill")
                            .foregroundColor(Color.brandPrimary.opacity(0.5))
                            .font(.system(size: 24))
                    }
                    
                    if isSelected {
                        Circle()
                            .fill(Color.brandPrimary)
                            .frame(width: 20, height: 20)
                            .overlay(
                                Image(systemName: "checkmark")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(.white)
                            )
                            .offset(x: 2, y: 2)
                    }
                }
                
                VStack(alignment: .leading, spacing: Spacing.s4) {
                    Text(patient.name)
                        .carelyText(style: .bodyRegular, weight: isSelected ? .medium : .regular)
                        .foregroundColor(.primaryFont)
                    
                    Text(patient.relation)
                        .carelyText(style: .caption, weight: .medium)
                        .padding(.horizontal, Spacing.s12)
                        .padding(.vertical, Spacing.s4)
                        .background(
                            Capsule().fill(isSelected ? Color.brandPrimary : Color.brandPrimary.opacity(0.15))
                        )
                        .foregroundColor(isSelected ? .white : .brandPrimary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondaryFont)
            }
            .padding(Spacing.s16)
            .background(isSelected ? Color.white : Color.white.opacity(0.5))
            .cornerRadius(Spacing.s20)
            .shadow(color: isSelected ? Color.black.opacity(0.05) : Color.clear, radius: 8, x: 0, y: 2)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack(spacing: Spacing.s16) {
        PatientSelectionCard(
            patient: AIPatient(id: "1", name: "Elena Rodriguez", relation: "Self", isSelf: true),
            isSelected: true,
            action: {}
        )
        
        PatientSelectionCard(
            patient: AIPatient(id: "2", name: "Robert Chen", relation: "Dad", isSelf: false),
            isSelected: false,
            action: {}
        )
    }
    .padding()
    .background(Color.backGround)
}
