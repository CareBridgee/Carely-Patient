//
//  CustomDatePickerView.swift
//  Carely
//
//  Created by Mona Zarea on 16/07/2026.
//

import SwiftUI

struct CustomDatePickerView: View {
    let title: String
    @Binding var selectedDate: Date
    var errorMessage: String? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.s2) {
            Text(title)
                .carelyText(style: .bodySmall, weight: .medium)
                .foregroundColor(Color.secondaryFont)
            
            HStack {
                DatePicker("", selection: $selectedDate, displayedComponents: .date)
                    .labelsHidden()
                    .colorMultiply(Color.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Image(systemName: "calendar")
                    .foregroundColor(Color.primary)
            }
            .padding(.horizontal, Spacing.s12)
            .padding(.vertical, Spacing.s4)
            .background(Color.surfaceVariant)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(errorMessage != nil ? Color.error : Color.clear, lineWidth: 1)
            )
            
            if let error = errorMessage {
                Text(error)
                    .carelyText(style: .caption)
                    .foregroundColor(Color.error)
                    .padding(.leading, Spacing.s2)
            }
        }
    }
}
