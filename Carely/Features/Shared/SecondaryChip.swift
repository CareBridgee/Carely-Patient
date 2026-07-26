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
    var foreground: Color = .brandPrimary
    var borderColor: Color = .hint
    var isSelected: Bool = false
    var textStyle: CarelyTextStyle = .bodyRegular
    var paddingHorizontal: CGFloat = 20
    var paddingVertical: CGFloat = 12

    var body: some View {
        Text(title)
            .carelyText(style: textStyle)
            .foregroundColor(isSelected ? Color.onSecondary : foreground)
            .padding(.horizontal, paddingHorizontal)
            .padding(.vertical, paddingVertical)
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
