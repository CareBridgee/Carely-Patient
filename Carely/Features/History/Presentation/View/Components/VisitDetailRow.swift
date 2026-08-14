//
//  VisitDetailRow.swift
//  Carely
//
//  Created by Mina on 14/08/2026.
//

import SwiftUI
 
struct VisitDetailRow: View {
    let iconName: String
    let label: String
    let value: String
 
    var body: some View {
        HStack(spacing: Spacing.s12) {
            ZStack {
                RoundedRectangle.carely(Radius.r12)
                    .fill(Color.primaryContainer.opacity(0.3))
                    .frame(width: 40, height: 40)
 
                Image(systemName: iconName)
                    .foregroundColor(.brandPrimary)
            }
 
            VStack(alignment: .leading, spacing: Spacing.s4) {
                Text(label)
                    .carelyText(style: .caption)
                    .foregroundColor(.secondaryFont)
 
                Text(value)
                    .carelyText(style: .bodyRegular, weight: .bold)
                    .foregroundColor(.primaryFont)
            }
 
            Spacer()
        }
    }
}
 
