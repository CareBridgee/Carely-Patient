//
//  PrimaryButton.swift
//  Carely
//
//  Created by Mona Zarea on 16/07/2026.
//

import SwiftUI


public enum PrimaryButtonSize {
    case small
    case medium
    case large
 
    var height: CGFloat {
        switch self {
        case .small: return Spacing.s40
        case .medium: return Spacing.s48
        case .large: return Spacing.s56
        }
    }
 
    var horizontalPadding: CGFloat {
        switch self {
        case .small: return Spacing.s16
        case .medium: return Spacing.s20
        case .large: return Spacing.s24
        }
    }
 
    var contentSpacing: CGFloat {
        switch self {
        case .small: return Spacing.s8
        case .medium: return Spacing.s8
        case .large: return Spacing.s12
        }
    }
 
    var textStyle: CarelyTextStyle {
        switch self {
        case .small: return .bodySmall
        case .medium: return .button
        case .large: return .bodyLarge
        }
    }
 
    var iconSize: CGFloat {
        switch self {
        case .small: return IconSize.s16
        case .medium: return IconSize.s20
        case .large: return IconSize.s24
        }
    }
 

    var defaultRadius: CGFloat {
        switch self {
        case .small: return Radius.r8
        case .medium: return Radius.r12
        case .large: return Radius.r16
        }
    }

    var loadingScale: CGFloat {
        switch self {
        case .small: return 0.7
        case .medium: return 0.85
        case .large: return 1.0
        }
    }
}
 

 
public enum PrimaryButtonIconPosition {
    case leading
    case trailing
}
 

public struct PrimaryButton: View {
 
    private let title: String
    private let size: PrimaryButtonSize
    private let customIconSize: CGFloat?
    private let radius: CGFloat
    private let icon: String?
    private let iconPosition: PrimaryButtonIconPosition
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
    public init(
        title: String,
        size: PrimaryButtonSize = .medium,
        customIconSize: CGFloat? = nil,
        radius: CGFloat? = nil,
        icon: String? = nil,
        iconPosition: PrimaryButtonIconPosition = .leading,
        isFullWidth: Bool = true,
        isLoading: Bool = false,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
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
        isEnabled ? .brandPrimary : .disable
    }
 
    private var foregroundColor: Color {
        isEnabled ? .onPrimary : .onDisable
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
            .animation(TrueFitMotion.springSnappy, value: configuration.isPressed)
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
