//
//  loginButton.swift
//  Carely
//
//  Created by Mina on 16/07/2026.
//

import SwiftUI

struct loginButton: View {
    let title: String
    let image: Image?
    let backgroundColor: Color
    let foregroundColor: Color
    let horizontalPadding : CGFloat
    let action: () -> Void
    let strokeColor: Color
    init(
        title: String,
        image: Image? = nil,
        backgroundColor: Color = .blue,
        foregroundColor: Color = .white,
        horizontalPadding: CGFloat = 24,
        strokeColor: Color,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.image = image
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.horizontalPadding = horizontalPadding
        self.action = action
        self.strokeColor = strokeColor
    }
    
    var body: some View {
        Button(action: action){
            HStack(spacing: 8) {
                if let image {
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }

                Text(title)
                    .carelyText(style: .bodyLarge, weight: .light)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundStyle(foregroundColor)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 32))
            .overlay(
                RoundedRectangle(cornerRadius: 32)
                    .stroke(strokeColor, lineWidth: 0.5)
            )
        }.padding(.horizontal, horizontalPadding)
            .padding(.bottom, 8)
        
    }
}
