//
//  SkipForNowButton.swift
//  Carely
//
//  Created by Mohamed Ayman on 17/07/2026.
//

import SwiftUI

struct SkipForNowButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: Spacing.s4) {
                    Text("Skip for Now")
                        .carelyText(style: .button, weight: .bold)
                        .foregroundStyle(Color.primary)

                    Text("Set up your profile later")
                        .carelyText(style: .bodySmall, weight: .regular)
                        .foregroundStyle(Color.secondaryFont)
                }

                Spacer()

                Image(systemName: "arrow.right")
                    .font(.system(size: IconSize.s20, weight: .bold))
                    .foregroundStyle(Color.primary)
            }
            .padding(.horizontal, Spacing.s24)
            .padding(.vertical, Spacing.s20)
            .background(
                RoundedRectangle.trueFit(Radius.r24)
                    .fill(Color.surface)
                    .overlay(
                        RoundedRectangle.trueFit(Radius.r24)
                            .stroke(Color.divider, lineWidth: 1)
                    )
            )
        }
    }
}
