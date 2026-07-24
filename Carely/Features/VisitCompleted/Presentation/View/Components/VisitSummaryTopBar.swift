//
//  VisitSummaryTopBar.swift
//  Carely
//
//  Created by Mina on 24/07/2026.
//

import SwiftUI
 
struct VisitSummaryTopBar: View {
    var onMenuTapped: () -> Void = {}
 
    var body: some View {
        HStack(spacing: Spacing.s12) {
            Button(action: onMenuTapped) {
                Image(systemName: "line.3.horizontal")
                    .foregroundColor(.brandPrimary)
                    .carelyText(style: .bodyLarge, weight: .semiBold)
            }
 
            Text("CareMatch")
                .carelyText(style: .heading3, weight: .bold)
                .foregroundColor(.brandPrimary)
 
            Spacer()
 
            Circle()
                .fill(Color.primaryContainer.opacity(0.4))
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: "person.fill")
                        .foregroundColor(.brandPrimary)
                )
                .overlay(
                    Circle().stroke(Color.brandPrimary, lineWidth: 2)
                )
        }
    }
}
 
//#Preview {
//    VisitSummaryTopBar()
//        .padding()
//        .background(Color.backGround)
//}
