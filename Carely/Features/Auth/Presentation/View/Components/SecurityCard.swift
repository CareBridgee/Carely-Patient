//
//  SecurityCard.swift
//  Carely
//
//  Created by Mina on 17/07/2026.
//

import SwiftUI

struct SecurityCard: View {

    var body: some View {

        HStack(spacing: 16) {

            Circle()
                .fill(Color.brandPrimary.opacity(0.12))
                .frame(width: 56, height: 56)
                .overlay {
                    Image.secureCare
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color.brandPrimary)
                }

            VStack(alignment: .leading) {

                Text("Secure Care")
                    .carelyText(style: .bodyLarge)
                    .foregroundColor(Color.primaryFont)

                Text("Your number is used only for verification and secure coordination of services.")
                    .carelyText(style: .bodySmall)
                    .foregroundStyle(Color.hint)
            }

            Spacer()
        }
        .padding()
        .background(Color.surface)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.06), radius: 10)
    }
}

#Preview {
    SecurityCard()
}
