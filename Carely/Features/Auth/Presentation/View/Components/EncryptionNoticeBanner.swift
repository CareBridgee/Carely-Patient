//
//  EncryptionNoticeBanner.swift
//  Carely
//
//  Created by Mohamed Ayman on 17/07/2026.
//

import SwiftUI

struct EncryptionNoticeBanner: View {
    let message: String

    var body: some View {
        HStack(alignment: .top, spacing: Spacing.s12) {
            Image(systemName: "lock.shield.fill")
                .foregroundStyle(Color.brandPrimary.opacity(0.7))
                .font(.system(size: IconSize.s16))
                .padding(.top, 1)

            Text(message)
                .carelyText(style: .caption, weight: .regular)
                .foregroundStyle(Color.secondaryFont)
                .lineSpacing(2)

            Spacer()
        }
        .padding(Spacing.s16)
        .background(
            RoundedRectangle.carely(Radius.r16)
                .fill(Color.surfaceVariant.opacity(0.6))
        )
    }
}
