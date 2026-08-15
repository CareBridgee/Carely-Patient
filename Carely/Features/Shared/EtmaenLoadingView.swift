//
//  EtmaenLoadingView.swift
//  Carely
//
//  Created by Mohamed Ayman on 14/08/2026.
//

import SwiftUI

// MARK: - Custom Etmaen Brand Spinner

public struct EtmaenSpinner: View {
    let size: CGFloat
    let lineWidth: CGFloat
    
    @State private var isSpinning: Bool = false
    @State private var pulseScale: CGFloat = 1.0
    
    public init(size: CGFloat = 44, lineWidth: CGFloat = 3.5) {
        self.size = size
        self.lineWidth = lineWidth
    }
    
    public var body: some View {
        ZStack {
            Circle()
                .stroke(Color.primaryContainer.opacity(0.4), lineWidth: lineWidth)
                .frame(width: size, height: size)
            
            Circle()
                .trim(from: 0.08, to: 0.78)
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [
                            Color.brandPrimary.opacity(0.15),
                            Color.brandPrimary
                        ]),
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .frame(width: size, height: size)
                .rotationEffect(.degrees(isSpinning ? 360 : 0))
            
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color.brandPrimary.opacity(0.2),
                            Color.clear
                        ]),
                        center: .center,
                        startRadius: 0,
                        endRadius: size * 0.45
                    )
                )
                .frame(width: size * 0.9, height: size * 0.9)
                .scaleEffect(pulseScale)
        }
        .onAppear {
            withAnimation(
                .linear(duration: 1.0)
                .repeatForever(autoreverses: false)
            ) {
                isSpinning = true
            }
            
            withAnimation(
                .easeInOut(duration: 0.8)
                .repeatForever(autoreverses: true)
            ) {
                pulseScale = 1.15
            }
        }
    }
}

// MARK: - Reusable Etmaen Loading View

public struct EtmaenLoadingView: View {
    let message: String?
    
    public init(message: String? = nil) {
        self.message = message
    }
    
    public var body: some View {
        VStack(spacing: Spacing.s16) {
            EtmaenSpinner(size: 44, lineWidth: 3.5)
            
            if let message, !message.isEmpty {
                Text(message)
                    .carelyText(style: .bodyRegular, weight: .semiBold)
                    .foregroundColor(Color.primaryFont)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
        .padding(.horizontal, Spacing.s32)
        .padding(.vertical, Spacing.s24)
        .background(
            RoundedRectangle.carely(Radius.r24)
                .fill(Color.surface)
                .overlay(
                    RoundedRectangle.carely(Radius.r24)
                        .stroke(Color.primaryContainer.opacity(0.2), lineWidth: 1)
                )
        )
        .carelyShadow(.lg)
    }
}

// MARK: - Loading Overlay Modifier

public struct EtmaenLoadingOverlayModifier: ViewModifier {
    let isPresented: Bool
    let message: String?
    
    public func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(isPresented)
                .blur(radius: isPresented ? 2.5 : 0)
            
            if isPresented {
                ZStack {
                    Color.primaryFont.opacity(0.18)
                        .ignoresSafeArea()
                    
                    EtmaenLoadingView(message: message)
                }
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
                .zIndex(999)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: isPresented)
    }
}

public extension View {
    func etmaenLoadingOverlay(isPresented: Bool, message: String? = "Please wait...") -> some View {
        self.modifier(EtmaenLoadingOverlayModifier(isPresented: isPresented, message: message))
    }
}

#Preview {
    ZStack {
        Color.backGround.ignoresSafeArea()
        EtmaenLoadingView(message: "Loading Profile Data...")
    }
}

