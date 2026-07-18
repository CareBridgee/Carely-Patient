//
//  SecondaryChip.swift
//  Carely
//
//  Created by Mina on 18/07/2026.
//

import SwiftUI

struct SecondaryChip: View {
    let title: String
    var background: Color = .backGround
    var foreground: Color = .primaryFont
    var borderColor: Color = .hint
    var isSelected: Bool = false

    var body: some View {
        Text(title)
            .carelyText(style: .bodyRegular)
            .foregroundColor(isSelected ? Color.onSecondary : foreground)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(isSelected ? foreground : background)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(isSelected ? foreground : borderColor, lineWidth: 1.5)
            )
    }
}

#Preview {
    SecondaryChip(title: "Peanuts", isSelected:false)
}
