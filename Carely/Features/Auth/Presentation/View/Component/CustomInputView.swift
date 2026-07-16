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
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(Color.secondaryFont)
            
        TextField(placeholder, text: $text)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(bg)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(errorMessage != nil ? Color.error : Color.clear, lineWidth: 1)
            )
        if let error = errorMessage {
            Text(error)
            .font(.caption)
            .foregroundColor(Color.error)
            .padding(.leading, 4)
        }
        }
    }
}
