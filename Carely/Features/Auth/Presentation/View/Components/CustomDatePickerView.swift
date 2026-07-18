//
//  CustomDatePickerView.swift
//  Carely
//
//  Created by Mona Zarea on 16/07/2026.
//

import SwiftUI

struct CustomDatePickerView: View {
    let title: String
    @Binding var selectedDate: Date?
    var errorMessage: String? = nil
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.s8) {
            Text(title)
                .carelyText(style: .bodySmall, weight: .medium)
                .foregroundColor(Color.secondaryFont)
            
            HStack {
                if let date = selectedDate {
                    Text(dateFormatter.string(from: date))
                        .carelyText(style: .bodyRegular)
                        .foregroundColor(Color.primaryFont)
                } else {
                    Text("mm/dd/yyyy")
                        .carelyText(style: .bodyRegular)
                        .foregroundColor(Color.hint)
                }
                
                Spacer()
                
                ZStack {
                    Image("calender-icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: IconSize.s20, height: IconSize.s20)
                        .foregroundColor(Color.brandPrimary)
                    
                    DatePicker("", selection: Binding<Date>(
                        get: { self.selectedDate ?? Date() },
                        set: { self.selectedDate = $0 }
                    ), displayedComponents: .date)
                        .labelsHidden()
                        .colorMultiply(.clear)
                        .opacity(0.011)
                        .frame(width: 40, height: 40)
                        .clipped()
                }
            }
            .padding(.horizontal, Spacing.s12)
            .frame(height: 52)
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

