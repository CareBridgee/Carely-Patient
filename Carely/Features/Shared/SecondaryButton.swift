//
//  SecondaryButton.swift
//  Carely
//
//  Created by Mohamed Ayman on 18/07/2026.
//

import SwiftUI



public struct SecondaryButton: View {
    private let title: String
    private let size: CarelyButtonSize
    private let radius: CGFloat
    private let icon: String?
    private let iconPosition: CarelyButtonIconPosition
    private let isFullWidth: Bool
    private let isLoading: Bool
    private let isEnabled: Bool
    private let action: () -> Void
    
    init(
        title: String,
        size: CarelyButtonSize = .medium,
        radius: CGFloat? = nil,
        icon: String? = nil,
        iconPosition: CarelyButtonIconPosition = .leading,
        isFullWidth: Bool = true,
        isLoading: Bool = false,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.size = size
        self.radius = radius ?? size.defaultRadius
        self.icon = icon
        self.iconPosition = iconPosition
        self.isFullWidth = isFullWidth
        self.isLoading = isLoading
        self.isEnabled = isEnabled
        self.action = action
    }
    
    private var isInteractive: Bool {
        isEnabled && !isLoading
    }
    
    private var backgroundColor: Color {
        isEnabled ? .mintSurface : .disable
    }
    
    private var foregroundColor: Color {
        isEnabled ? .primary : .onDisable
    }
    
    public var body: some View {
        Button(action: action) {
            HStack(spacing: size.contentSpacing) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(foregroundColor)
                        .scaleEffect(size.loadingScale)
                } else {
                    if let icon, iconPosition == .leading {
                        iconView(icon)
                    }
                    Text(title)
                        .carelyText(style: size.textStyle, weight: .semiBold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.9)
                    if let icon, iconPosition == .trailing {
                        iconView(icon)
                    }
                }
            }
            .foregroundColor(foregroundColor)
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .frame(height: size.height)
            .padding(.horizontal, size.horizontalPadding)
            .background(backgroundColor)
            .clipShape(RoundedRectangle.trueFit(radius))
        }
        .buttonStyle(SecondaryButtonPressStyle())
        .disabled(!isInteractive)
        .accessibilityLabel(title)
        .accessibilityAddTraits(.isButton)
    }
    
    @ViewBuilder
    private func iconView(_ systemName: String) -> some View {
        Image(systemName: systemName)
            .resizable()
            .scaledToFit()
            .frame(width: size.iconSize, height: size.iconSize)
    }
}

private struct SecondaryButtonPressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .opacity(configuration.isPressed ? 0.9 : 1)
            .animation(TrueFitMotion.springSnappy, value: configuration.isPressed)
    }
}

#Preview {
    ScrollView {
        VStack(spacing: Spacing.s24) {
            SecondaryButton(title: "Skip for Now") {}
            SecondaryButton(
                title: "Skip for Now",
                icon: "arrow.right",
                iconPosition: .trailing
            ) {}
            SecondaryButton(title: "Set up profile later", size: .large) {}
            SecondaryButton(
                title: "Back",
                size: .small,
                radius: Radius.pill,
                isFullWidth: false
            ) {}
            SecondaryButton(title: "Saving...", isLoading: true) {}
            SecondaryButton(title: "Skip for Now", isEnabled: false) {}
        }
        .padding(Spacing.s16)
    }
    .background(Color.backGround)
}
