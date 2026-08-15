//
//  EtmaenShimmer.swift
//  Carely
//
//  Created by Mohamed Ayman on 14/08/2026.
//

import SwiftUI

// MARK: - Shimmer Effect Modifier

private struct ShimmerAnimatableModifier: AnimatableModifier {
    var phase: CGFloat
    
    var animatableData: CGFloat {
        get { phase }
        set { phase = newValue }
    }
    
    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: .clear, location: 0.0),
                        .init(color: Color.primaryFont.opacity(0.12), location: 0.5),
                        .init(color: .clear, location: 1.0)
                    ]),
                    startPoint: UnitPoint(x: -1.0 + phase * 2.5, y: 0.5),
                    endPoint: UnitPoint(x: 0.0 + phase * 2.5, y: 0.5)
                )
                .allowsHitTesting(false)
            )
            .mask(content)
    }
}

public struct EtmaenShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = 0.0
    
    public func body(content: Content) -> some View {
        content
            .modifier(ShimmerAnimatableModifier(phase: phase))
            .onAppear {
                withAnimation(
                    .linear(duration: 1.4)
                    .repeatForever(autoreverses: false)
                ) {
                    phase = 1.0
                }
            }
    }
}

public extension View {
    /// Applies a hardware-accelerated shimmer animation to any view or skeleton block without altering layout geometry.
    func etmaenShimmer() -> some View {
        self.modifier(EtmaenShimmerModifier())
    }
}

// MARK: - Skeleton Primitives

public struct EtmaenSkeletonRect: View {
    let width: CGFloat?
    let height: CGFloat
    let radius: CGFloat
    
    public init(width: CGFloat? = nil, height: CGFloat = 16, radius: CGFloat = Radius.r8) {
        self.width = width
        self.height = height
        self.radius = radius
    }
    
    public var body: some View {
        Group {
            if let width {
                RoundedRectangle.carely(radius)
                    .fill(Color.surfaceVariant)
                    .frame(width: width, height: height)
            } else {
                RoundedRectangle.carely(radius)
                    .fill(Color.surfaceVariant)
                    .frame(height: height)
                    .frame(maxWidth: .infinity)
            }
        }
        .etmaenShimmer()
    }
}

public struct EtmaenSkeletonCircle: View {
    let size: CGFloat
    
    public init(size: CGFloat = 44) {
        self.size = size
    }
    
    public var body: some View {
        Circle()
            .fill(Color.surfaceVariant)
            .frame(width: size, height: size)
            .etmaenShimmer()
    }
}

public struct EtmaenSkeletonText: View {
    let lines: Int
    let lineHeight: CGFloat
    let spacing: CGFloat
    
    public init(lines: Int = 2, lineHeight: CGFloat = 14, spacing: CGFloat = Spacing.s8) {
        self.lines = lines
        self.lineHeight = lineHeight
        self.spacing = spacing
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            ForEach(0..<lines, id: \.self) { index in
                EtmaenSkeletonRect(
                    width: index == lines - 1 && lines > 1 ? 160 : nil,
                    height: lineHeight,
                    radius: Radius.r8
                )
            }
        }
    }
}

// MARK: - Skeleton Card Templates

public struct EtmaenCardSkeleton: View {
    let height: CGFloat?
    
    public init(height: CGFloat? = nil) {
        self.height = height
    }
    
    public var body: some View {
        HStack(spacing: Spacing.s16) {
            EtmaenSkeletonCircle(size: 48)
            
            VStack(alignment: .leading, spacing: Spacing.s8) {
                EtmaenSkeletonRect(width: 140, height: 16, radius: Radius.r8)
                EtmaenSkeletonRect(width: 200, height: 12, radius: Radius.r8)
            }
            
            Spacer(minLength: 0)
        }
        .padding(Spacing.s16)
        .frame(height: height)
        .background(Color.surface)
        .clipShape(RoundedRectangle.carely(Radius.r16))
        .carelyShadow(.sm)
    }
}

public struct EtmaenServiceGridSkeleton: View {
    public init() {}
    
    public var body: some View {
        LazyVGrid(
            columns: [GridItem(.flexible(), spacing: Spacing.s12), GridItem(.flexible(), spacing: Spacing.s12)],
            spacing: Spacing.s12
        ) {
            ForEach(0..<6, id: \.self) { _ in
                VStack(alignment: .leading, spacing: Spacing.s12) {
                    EtmaenSkeletonCircle(size: 44)
                    
                    VStack(alignment: .leading, spacing: Spacing.s4) {
                        EtmaenSkeletonRect(width: 100, height: 16, radius: Radius.r8)
                        EtmaenSkeletonRect(width: 70, height: 12, radius: Radius.r8)
                    }
                    
                    Spacer(minLength: 0)
                }
                .padding()
                .frame(maxWidth: .infinity, minHeight: 140, alignment: .topLeading)
                .background(Color.surface)
                .cornerRadius(Radius.r20)
                .carelyShadow(.sm)
            }
        }
    }
}

public struct EtmaenListSkeleton: View {
    let count: Int
    
    public init(count: Int = 4) {
        self.count = count
    }
    
    public var body: some View {
        VStack(spacing: Spacing.s16) {
            ForEach(0..<count, id: \.self) { _ in
                EtmaenCardSkeleton()
            }
        }
    }
}

#Preview {
    ZStack {
        Color.backGround.ignoresSafeArea()
        ScrollView {
            VStack(spacing: Spacing.s20) {
                EtmaenCardSkeleton()
                EtmaenServiceGridSkeleton()
            }
            .padding()
        }
    }
}
