//
//  EtmaenLoadingView.swift
//  Carely
//
//  Created by Mohamed Ayman on 14/08/2026.
//

import SwiftUI

// MARK: - Reusable Lightweight Blocking Loading Overlay

public struct EtmaenLoadingOverlayModifier: ViewModifier {
    let isPresented: Bool
    let message: String?
    
    public func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(isPresented)
            
            if isPresented {
                ZStack {
                    Color.black.opacity(0.12)
                        .ignoresSafeArea()
                    
                    VStack(spacing: Spacing.s12) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.brandPrimary))
                            .scaleEffect(1.2)
                        
                        if let message, !message.isEmpty {
                            Text(message)
                                .carelyText(style: .bodySmall, weight: .medium)
                                .foregroundColor(Color.primaryFont)
                        }
                    }
                    .padding(.horizontal, Spacing.s24)
                    .padding(.vertical, Spacing.s16)
                    .background(Color.surface)
                    .clipShape(RoundedRectangle.carely(Radius.r16))
                    .carelyShadow(.sm)
                }
                .transition(.opacity)
                .zIndex(999)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isPresented)
    }
}

public extension View {
    /// Applies a lightweight blocking loading overlay using native ProgressView.
    func etmaenLoadingOverlay(isPresented: Bool, message: String? = nil) -> some View {
        self.modifier(EtmaenLoadingOverlayModifier(isPresented: isPresented, message: message))
    }
}

