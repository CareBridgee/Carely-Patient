//
//  TotalAmountDueCard.swift
//  Carely
//
//  Created by Mina on 24/07/2026.
//

import SwiftUI
 
struct TotalAmountDueCard: View {
    let amountText: String
 
    var body: some View {
        HStack {
            Text("TOTAL AMOUNT DUE")
                .carelyText(style: .caption, weight: .bold)
                .foregroundColor(.brandPrimary)
 
            Spacer()
 
            Text(amountText)
                .carelyText(style: .bodyRegular)
                .foregroundColor(.brandPrimary)
        }
        .padding(Spacing.s20)
        .frame(maxWidth: .infinity)
        .background(Color.surface)
        .clipShape(RoundedRectangle.carely(Radius.r24))
        .carelyShadow(.sm)
    }
}
 
//#Preview {
//    TotalAmountDueCard(amountText: "$85.00")
//        .padding()
//        .background(Color.backGround)
//}
// 
