//
//  HomeTopBar.swift
//  Carely
//
//  Created by Mina on 22/07/2026.
//

import SwiftUI
 
struct HomeTopBar: View {
    let image : Image = Image(systemName: "person.fill")
    let greetingName: String
    var onNotificationsTapped: (() -> Void)
    
    var body: some View {
        HStack(spacing: Spacing.s12) {
            Circle()
                .fill(Color.primaryContainer.opacity(0.15))
                .frame(width: 40, height: 40)
                .overlay(
                    image
                        .foregroundColor(.brandPrimary)
                )
                .overlay(
                    Circle().stroke(Color.primaryContainer, lineWidth: 2)
                )
 
            Text("Hi, \(greetingName)")
                .carelyText(style: .heading3, weight: .semiBold)
                .foregroundColor(.brandPrimary)
 
            Spacer()
 
            Button {
                onNotificationsTapped()
            } label: {
                Image(systemName: "bell")
                    .foregroundColor(.secondaryFont)
                    .frame(width: 40, height: 40)
                    .background(Color.surface)
                    .clipShape(Circle())
            }
        }
    }
}
 
//#Preview {
//    HomeTopBar(greetingName: "Elena", onNotificationsTapped: {})
//        .padding()
//        .background(Color.backGround)
//}
// 
