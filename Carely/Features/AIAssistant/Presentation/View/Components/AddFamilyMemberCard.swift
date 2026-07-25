//
//  AddFamilyMemberCard.swift
//  Carely
//
//  Created by AI Assistant
//

import SwiftUI

struct AddFamilyMemberCard: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: Spacing.s8) {
                Circle()
                    .fill(Color.brandPrimary.opacity(0.15))
                    .frame(width: 48, height: 48)
                    .overlay(
                        Image(systemName: "person.badge.plus")
                            .font(.system(size: 20))
                            .foregroundColor(.brandPrimary)
                    )
                
                Text("Add Family Member")
                    .carelyText(style: .bodyRegular, weight: .medium)
                    .foregroundColor(.brandPrimary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, Spacing.s16)
            .background(Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: Spacing.s20)
                    .strokeBorder(Color.secondaryFont.opacity(0.5), style: StrokeStyle(lineWidth: 1, dash: [6]))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
