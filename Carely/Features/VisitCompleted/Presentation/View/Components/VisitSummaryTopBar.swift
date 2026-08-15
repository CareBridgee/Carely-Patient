//
//  VisitSummaryTopBar.swift
//  Carely
//
//  Created by Mina on 24/07/2026.
//

import SwiftUI
 
struct VisitSummaryTopBar: View {
    var body: some View {
        HStack {
            Spacer()

            Text("Visit Summary")
                .carelyText(style: .heading3, weight: .bold)
                .foregroundColor(.primaryFont)

            Spacer()
        }
        .padding(.vertical, Spacing.s12)
    }
}
 
//#Preview {
//    VisitSummaryTopBar()
//        .padding()
//        .background(Color.backGround)
//}
