//
//  PrimaryButton.swift
//  Carely
//
//  Created by Mona Zarea on 16/07/2026.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    var iconName: String? = nil
    var isLoading: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView().tint(.white)
                } else {
                    Text(title)
                    
                    if let iconName = iconName {
                        Image(systemName: iconName)
                    }
                }
            }
            .font(.headline)
            .foregroundColor(Color.onPrimary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.primary)
            .cornerRadius(12)
        }
        .disabled(isLoading)
    }
}
