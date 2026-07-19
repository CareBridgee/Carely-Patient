//
//  CompleteHealthProfileButton.swift
//  Carely
//
//  Created by Mohamed Ayman on 17/07/2026.
//

import SwiftUI

struct CompleteHealthProfileButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: Spacing.s4) {
                    Text("Complete Health Profile")
                        .carelyText(style: .button, weight: .bold)

                    Text("(RECOMMENDED)")
                        .carelyText(style: .caption, weight: .semiBold)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: IconSize.s20, weight: .bold))
            }
            .foregroundStyle(Color.onPrimary)
            .padding(.horizontal, Spacing.s24)
            .padding(.vertical, Spacing.s20)
            .background(
                RoundedRectangle.carely(Radius.r24)
                    .fill(Color.brandPrimary)
            )
        }
    }
}
