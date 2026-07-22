//
//  SearchField.swift
//  Carely
//
//  Created by Mina on 22/07/2026.
//

import SwiftUI
 
struct SearchField: View {
    let placeholder: String
    @Binding var text: String
 
    var body: some View {
        HStack(spacing: Spacing.s12) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.hint)
 
            TextField(placeholder, text: $text)
                .carelyText(style: .bodyRegular)
                .foregroundColor(.primaryFont)
                .tint(.brandPrimary)
        }
        .padding(.horizontal, Spacing.s16)
        .frame(height: Spacing.s56)
        .background(Color.surface)
        .clipShape(RoundedRectangle.carely(Radius.r24))
        .carelyShadow(.sm)
    }
}
 
#Preview {
    SearchField(placeholder: "Search services, symptoms...", text: .constant(""))
        .padding()
        .background(Color.backGround)
}
 
