//
//  Typography.swift
//  TrueFit Design System
//
//  Font pairing: SF Pro Rounded (Bold/Semibold) for Display→Headline tiers
//  SF Pro Text (Regular/Medium) for Body→Caption tiers
//
//  Hierarchy rule: never use more than 3 type styles on a single screen
//  below the fold. Display/Large Title are reserved for first-screen-of-flow
//  moments (onboarding, empty states).
//

import SwiftUI

// MARK: - TrueFit Font Scale

public extension Font {

    /// 34pt Bold Rounded · tracking -0.4 · line height 41
    /// Splash hero headline ("Choose Dress")
    static let trueFitDisplay = Font.system(size: 34, weight: .bold, design: .rounded)

    /// 28pt Bold Rounded · tracking -0.3 · line height 34
    /// Screen-level hero titles
    static let trueFitLargeTitle = Font.system(size: 28, weight: .bold, design: .rounded)

    /// 24pt Bold Rounded · tracking -0.2 · line height 30
    /// Section hero ("Welcome to the Dog's Fashion")
    static let trueFitTitle1 = Font.system(size: 24, weight: .bold, design: .rounded)

    /// 20pt Semibold Rounded · tracking -0.1 · line height 25
    /// "Trending", nav title "Products"
    static let trueFitTitle2 = Font.system(size: 20, weight: .semibold, design: .rounded)

    /// 18pt Semibold Rounded · tracking 0 · line height 23
    /// Card section headers
    static let trueFitTitle3 = Font.system(size: 18, weight: .semibold, design: .rounded)

    /// 17pt Semibold Default · tracking 0 · line height 22
    /// Product title ("HUFT Sweatshirt For Dogs…")
    static let trueFitHeadline = Font.system(size: 17, weight: .semibold, design: .default)

    /// 16pt Regular Default · tracking 0 · line height 22
    /// Description paragraphs
    static let trueFitBody = Font.system(size: 16, weight: .regular, design: .default)

    /// 15pt Regular Default · tracking 0 · line height 20
    /// Secondary CTA labels
    static let trueFitCallout = Font.system(size: 15, weight: .regular, design: .default)

    /// 14pt Regular Default · tracking 0 · line height 19
    /// Splash sub-copy, "Hello," greeting
    static let trueFitSubheadline = Font.system(size: 14, weight: .regular, design: .default)

    /// 13pt Regular Default · tracking 0.1 · line height 18
    /// "Swipe For More", size chip labels
    static let trueFitFootnote = Font.system(size: 13, weight: .regular, design: .default)

    /// 12pt Medium Default · tracking 0.2 · line height 16
    /// Rating value "4.2/5", price context
    static let trueFitCaption = Font.system(size: 12, weight: .medium, design: .default)

    /// 11pt Medium Default, uppercase · tracking 0.4 · line height 14
    /// Badge text ("All New Collection")
    static let trueFitCaption2 = Font.system(size: 11, weight: .medium, design: .default)
}

// MARK: - Tracking (Letter Spacing) Modifier

public extension View {

    /// Apply TrueFit-spec letter spacing for display-tier typography.
    /// Apple/Airbnb-grade headlines use slightly negative letter-spacing at large sizes.
    func trueFitTracking(_ style: TrueFitTypeStyle) -> some View {
        self.tracking(style.tracking)
    }
}

/// Typography style enum for applying correct tracking values.
public enum TrueFitTypeStyle {
    case display, largeTitle, title1, title2, title3
    case headline, body, callout, subheadline
    case footnote, caption, caption2

    /// Letter-spacing value from the spec
    public var tracking: CGFloat {
        switch self {
        case .display:      return -0.4
        case .largeTitle:   return -0.3
        case .title1:       return -0.2
        case .title2:       return -0.1
        case .title3:       return 0
        case .headline:     return 0
        case .body:         return 0
        case .callout:      return 0
        case .subheadline:  return 0
        case .footnote:     return 0.1
        case .caption:      return 0.2
        case .caption2:     return 0.4
        }
    }

    /// The corresponding `Font` token
    public var font: Font {
        switch self {
        case .display:      return .trueFitDisplay
        case .largeTitle:   return .trueFitLargeTitle
        case .title1:       return .trueFitTitle1
        case .title2:       return .trueFitTitle2
        case .title3:       return .trueFitTitle3
        case .headline:     return .trueFitHeadline
        case .body:         return .trueFitBody
        case .callout:      return .trueFitCallout
        case .subheadline:  return .trueFitSubheadline
        case .footnote:     return .trueFitFootnote
        case .caption:      return .trueFitCaption
        case .caption2:     return .trueFitCaption2
        }
    }
}

// MARK: - Convenience Text Modifier

public extension View {

    /// Apply both the correct font and tracking for a TrueFit type style.
    ///
    ///     Text("Choose Dress")
    ///         .trueFitTextStyle(.display)
    ///
    func trueFitTextStyle(_ style: TrueFitTypeStyle) -> some View {
        self
            .font(style.font)
            .tracking(style.tracking)
    }
}
