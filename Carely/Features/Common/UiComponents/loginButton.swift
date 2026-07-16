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
    
    init(
        title: String,
        image: Image? = nil,
        backgroundColor: Color = .blue,
        foregroundColor: Color = .white,
        horizontalPadding: CGFloat = 24,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.image = image
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.horizontalPadding = horizontalPadding
        self.action = action
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
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundStyle(foregroundColor)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 32))
        }.padding(.horizontal, horizontalPadding)
            .padding(.bottom, 8)
        
    }
}

#Preview {
    loginButton(title: "Continue with Apple", image: Image(systemName: "applelogo"), backgroundColor: .onSurface, foregroundColor: .surface, horizontalPadding: 24, action: {})
}
