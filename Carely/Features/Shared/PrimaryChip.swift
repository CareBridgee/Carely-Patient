//
//  PrimaryChip.swift
//  Carely
//
//  Created by Mina on 18/07/2026.
//

import SwiftUI

struct PrimaryChip: View {
    let image: Image
    let title: String
    var background: Color = .surface
    var foreground: Color = .primaryFont
    var isSelected: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            image
                .resizable()
                .scaledToFit()
                .frame(width: 48, height: 48)
                .foregroundColor(foreground)

            Text(title)
                .carelyText(style: .bodyLarge, weight: .light)
                .foregroundColor(foreground)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(isSelected ? foreground.opacity(0.08) : background)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isSelected ? foreground : Color(.hint), lineWidth: isSelected ? 1.5 : 1)
        )
    }
}

#Preview {
    PrimaryChip(image: .googleIcon, title: "Google", isSelected: false)
}
