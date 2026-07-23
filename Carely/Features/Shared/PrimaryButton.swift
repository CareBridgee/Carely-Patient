//
//  PrimaryButton.swift
//  Carely
//
//  Created by Mona Zarea on 16/07/2026.
//

import SwiftUI

public struct PrimaryButton: View {
    private let colorOfBackground: Color
    private let colorOfForground: Color
    private let title: String
    private let size: CarelyButtonSize
    private let customIconSize: CGFloat?
    private let radius: CGFloat
    private let icon: String?
    private let iconPosition: CarelyButtonIconPosition
    private let isFullWidth: Bool
    private let isLoading: Bool
    private let isEnabled: Bool
    private let action: () -> Void
 
    /// - Parameters:
    ///   - title: Button label.
    ///   - size: Drives height, padding, font, and icon size. Defaults to `.medium`.
    ///   - radius: Corner radius override. Defaults to `size.defaultRadius`. Pass `Radius.pill` for a pill button.
    ///   - icon: Optional SF Symbol name (e.g. `"arrow.right"`) shown next to the title.
    ///   - iconPosition: Where `icon` is placed relative to the title. Defaults to `.leading`.
    ///   - isFullWidth: Whether the button expands to fill available width. Defaults to `true`.
    ///   - isLoading: Shows a spinner in place of the title/icon and blocks interaction.
    ///   - isEnabled: Disables interaction and switches to the disabled color pair.
    ///   - action: Tap handler.
    init(
        colorOfBackground: Color = .brandPrimary,
        colorOfForground: Color = .onPrimary,
        title: String,
        size: CarelyButtonSize = .medium,
        customIconSize: CGFloat? = nil,
        radius: CGFloat? = nil,
        icon: String? = nil,
        iconPosition: CarelyButtonIconPosition = .leading,
        isFullWidth: Bool = true,
        isLoading: Bool = false,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.colorOfBackground = colorOfBackground
        self.colorOfForground = colorOfForground
        self.title = title
        self.size = size
        self.customIconSize = customIconSize
        self.radius = radius ?? size.defaultRadius
        self.icon = icon
        self.iconPosition = iconPosition
        self.isFullWidth = isFullWidth
        self.isLoading = isLoading
        self.isEnabled = isEnabled
        self.action = action
    }
 
    private var isInteractive: Bool { isEnabled && !isLoading }
 
    private var backgroundColor: Color {
        isEnabled ? colorOfBackground : .disable
    }
 
    private var foregroundColor: Color {
        isEnabled ? colorOfForground : .onDisable
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
            .clipShape(RoundedRectangle.carely(radius))
        }
        .buttonStyle(PrimaryButtonPressStyle())
        .disabled(!isInteractive)
        .accessibilityLabel(title)
        .accessibilityAddTraits(.isButton)
    }
 
    @ViewBuilder
    private func iconView(_ systemName: String) -> some View {
        let activeIconSize = customIconSize ?? size.iconSize
        Image(systemName: systemName)
            .resizable()
            .scaledToFit()
            .frame(width: activeIconSize, height: activeIconSize)
    }
}
 

private struct PrimaryButtonPressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .opacity(configuration.isPressed ? 0.9 : 1)
            .animation(CarelyMotion.springSnappy, value: configuration.isPressed)
    }
}
 
 
#Preview {
    ScrollView {
        VStack(spacing: Spacing.s24) {
            PrimaryButton(title: "Continue") {}
 
            PrimaryButton(
                title: "Continue",
                icon: "arrow.right",
                iconPosition: .trailing
            ) {}
 
            PrimaryButton(title: "Continue to Final Step", size: .large) {}
 
            PrimaryButton(
                title: "Back",
                size: .small,
                radius: Radius.pill,
                icon: "chevron.left",
                isFullWidth: false
            ) {}
 
            PrimaryButton(title: "Saving...", isLoading: true) {}
 
            PrimaryButton(title: "Continue", isEnabled: false) {}
        }
        .padding(Spacing.s16)
    }
    .background(Color.backGround)
}
