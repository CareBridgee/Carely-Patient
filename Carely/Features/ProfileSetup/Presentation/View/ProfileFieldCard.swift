//
//  ProfileFieldCard.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 20/07/2026.
//


import SwiftUI

struct ProfileFieldCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let placeholder: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.s12) {
            HStack(spacing: Spacing.s12) {
                ZStack {
                    Circle()
                        .fill(Color.mintSurface)
                        .frame(width: Spacing.s40, height: Spacing.s40)

                    Image(systemName: icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: IconSize.s20, height: IconSize.s20)
                        .foregroundColor(.brandPrimary)
                }

                VStack(alignment: .leading, spacing: Spacing.s2) {
                    Text(title)
                        .carelyText(style: .bodyRegular, weight: .semiBold)
                        .foregroundColor(.primaryFont)

                    Text(subtitle)
                        .carelyText(style: .caption, weight: .regular)
                        .foregroundColor(.secondaryFont)
                }

                Spacer(minLength: .zero)
            }

            CustomTextAreaView(placeholder: placeholder, text: $text, minHeight: 90)
        }
        .padding(Spacing.s16)
        .background(Color.surface)
        .clipShape(RoundedRectangle.carely(Radius.r16))
    }
}
