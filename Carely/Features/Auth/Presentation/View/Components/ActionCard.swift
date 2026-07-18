//
//  ActionCard.swift
//  Carely
//
//  Created by Mina on 17/07/2026.
//

import SwiftUI

struct ActionCard: View {
    let title: String
    let image: Image
    let backgroundColor: Color
    let foregroundColor: Color

    init(
        title: String,
        image: Image,
        backgroundColor: Color = Color(.systemGray6),
        foregroundColor: Color = .brandPrimary
    ) {
        self.title = title
        self.image = image
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
    }

    var body: some View {
        VStack{
            image
                .resizable()
                .scaledToFit()
                .frame(width: 48, height: 48)
                .foregroundStyle(foregroundColor)
            
            Text(title)
                .carelyText(style: .bodyRegular)
                .foregroundStyle(foregroundColor)
        }
        .frame(maxWidth: .infinity, minHeight: 110)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    ActionCard(title: "Instant SMS", image: Image(systemName: "ellipsis.message"), backgroundColor: .primaryContainer, foregroundColor: .onBankContainer)
}
