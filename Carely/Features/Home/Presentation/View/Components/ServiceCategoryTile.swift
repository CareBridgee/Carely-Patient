//
//  ServiceCategoryTile.swift
//  Carely
//
//  Created by Mina on 22/07/2026.
//

import SwiftUI

/// Compact 2-column grid tile shown in the Home screen's services preview.
struct ServiceCategoryTile: View {
    let title: String
    let iconName: String
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: Spacing.s12) {
                Image(systemName: iconName)
                    .font(.system(size: 22))
                    .foregroundColor(.brandPrimary)
                    .frame(width: 48, height: 48)
                    .background(Color.primaryContainer)
                    .clipShape(RoundedRectangle.carely(Radius.r16))

                Text(title)
                    .carelyText(style: .bodySmall)
                    .foregroundColor(.primaryFont)
            }
            .padding(Spacing.s16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.surface)
            .clipShape(RoundedRectangle.carely(Radius.r24))
            .carelyShadow(.sm)
        }
        .buttonStyle(.plain)
    }
}

//#Preview {
//    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: Spacing.s12) {
//        ServiceCategoryTile(title: "General Nursing", iconName: "cross.case.fill")
//        ServiceCategoryTile(title: "Injection Service", iconName: "cross.vial.fill")
//    }
//    .padding()
//    .background(Color.backGround)
//}
