//
//  AuthHeaderView.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 16/07/2026.
//


import SwiftUI

struct AuthHeaderView: View {
    let title: String
    let backAction: () -> Void
    
    var body: some View {
        HStack {
            Button(action: backAction) {
                Image(systemName: "chevron.left")
                    .foregroundStyle(Color.primaryFont)
            }
            Spacer()
            Text(title)
                .carelyText(style: .heading3, weight: .bold)
                .foregroundStyle(Color.primary)
            Spacer()
            Color.clear.frame(width: 20, height: 20)
        }
        .padding(.horizontal, Spacing.md)
        .padding(.vertical, Spacing.sm)
    }
}
struct OTPHeaderIconView: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.primaryContainer)
                .frame(width: 88, height: 88)
            Image(systemName: "iphone")
                .font(.system(size: 32, weight: .medium))
                .foregroundStyle(Color.primary)
        }
        .padding(.top, Spacing.md)
    }
}
