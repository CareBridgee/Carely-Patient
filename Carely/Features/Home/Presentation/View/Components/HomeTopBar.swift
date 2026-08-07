//
//  HomeTopBar.swift
//  Carely
//
//  Created by Mina on 22/07/2026.
//
//
//  HomeTopBar.swift
//  Carely
//

import SwiftUI

struct HomeTopBar: View {
    let greetingName: String
    let profileImageUrl: String? 
    var onNotificationsTapped: (() -> Void)
    
    var body: some View {
        HStack(spacing: Spacing.s12) {
            Circle()
                .fill(Color.primaryContainer.opacity(0.15))
                .frame(width: 40, height: 40)
                .overlay(
                    Group {
                        if let urlString = profileImageUrl, let url = URL(string: urlString) {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image.resizable().scaledToFill()
                                case .failure:
                                    Image(systemName: "person.fill").foregroundColor(.brandPrimary)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        } else {
                            Image(systemName: "person.fill")
                                .foregroundColor(.brandPrimary)
                        }
                    }
                    .clipShape(Circle())
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
