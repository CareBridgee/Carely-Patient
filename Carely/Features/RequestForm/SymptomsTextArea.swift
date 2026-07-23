//
//  SymptomsTextArea.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 22/07/2026.
//


import SwiftUI

struct SymptomsTextArea: View {
    @Binding var text: String
    let errorMessage: String?
    let onFillWithAI: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.s8) {
            Text("Describe the situation or symptoms")
                .carelyText(style: .bodyRegular, weight: .medium)
                .foregroundColor(.primaryFont)

            ZStack(alignment: .bottomTrailing) {
                CustomTextAreaView(
                    placeholder: "E.g., Feeling dehydrated after the flu, needs routine IV administration...",
                    text: $text,
                    minHeight: 140
                )

                Button(action: {}) {
                    Image(systemName: "mic.fill")
                        .foregroundColor(.hint)
                        .padding(Spacing.s12)
                }
            }

            if let errorMessage {
                Text(errorMessage)
                    .carelyText(style: .caption, weight: .medium)
                    .foregroundColor(.error)
            }
        }
    }
}