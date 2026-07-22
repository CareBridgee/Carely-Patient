//
//  IncludedItemRow.swift
//  Carely
//
//  Created by Mina on 22/07/2026.
//

import SwiftUI
 
struct IncludedItemRow: View {
    let text: String
 
    var body: some View {
        HStack(alignment: .top, spacing: Spacing.s12) {
            Image(systemName: "checkmark")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.onSecondary)
                .frame(width: 22, height: 22)
                .background(Color.secondaryColor)
                .clipShape(Circle())
 
            Text(text)
                .carelyText(style: .bodyRegular)
                .foregroundColor(.secondaryFont)
 
            Spacer()
        }
    }
}
 
#Preview {
    VStack(alignment: .leading, spacing: Spacing.s12) {
        IncludedItemRow(text: "In-home travel & setup by a Registered Nurse")
        IncludedItemRow(text: "Vital signs monitoring and health screening")
    }
    .padding()
    .background(Color.backGround)
}
