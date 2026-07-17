//
//  CustomInputView.swift
//  Carely
//
//  Created by Mona Zarea on 16/07/2026.
//

import SwiftUI

struct CustomInputView: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var errorMessage: String? = nil
    let bg: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xxs) {
            Text(title)
                .carelyText(style: .bodySmall, weight: .medium)
                .foregroundColor(Color.secondaryFont)
            
        TextField(placeholder, text: $text)
            .carelyText(style: .bodyRegular)
            .padding(.horizontal, Spacing.md)
            .padding(.vertical, Spacing.sm)
            .background(bg)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(errorMessage != nil ? Color.error : Color.clear, lineWidth: 1)
            )
        if let error = errorMessage {
            Text(error)
                .carelyText(style: .caption)
                .foregroundColor(Color.error)
            .padding(.leading, Spacing.xxs)
        }
        }
    }
}
