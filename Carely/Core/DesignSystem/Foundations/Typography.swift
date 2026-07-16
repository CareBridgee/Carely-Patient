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
import SwiftUI

enum CarelyFontWeight {
    case light
    case regular
    case medium
    case semiBold
    case bold
    
    /// Dynamically returns the correct font PostScript name based on the active language.
    func name(isArabic: Bool) -> String {
        switch self {
        case .light:
            return isArabic ? "Cairo-Light" : "Poppins-Light"
        case .regular:
            return isArabic ? "Cairo-Regular" : "Poppins-Regular"
        case .medium:
            return isArabic ? "Cairo-Medium" : "Poppins-Medium"
        case .semiBold:
            return isArabic ? "Cairo-SemiBold" : "Poppins-SemiBold"
        case .bold:
            return isArabic ? "Cairo-Bold" : "Poppins-Bold"
        }
    }
}

// MARK: - Text Styles (Sizes)
enum CarelyTextStyle {
    case display
    case heading1
    case heading2
    case heading3
    case bodyLarge
    case bodyRegular
    case bodySmall
    case button
    case caption
    
    /// The specific point size for each text style case.
    var size: CGFloat {
        switch self {
        case .display: return 40
        case .heading1: return 32
        case .heading2: return 24
        case .heading3: return 20
        case .bodyLarge: return 18
        case .bodyRegular: return 16
        case .bodySmall: return 14
        case .button: return 16
        case .caption: return 12
        }
    }
}

// MARK: - Custom View Modifier (Fully Reactive)
struct CarelyTypographyModifier: ViewModifier {
    let style: CarelyTextStyle
    let weight: CarelyFontWeight
    
    // Listens to the SwiftUI environment for instant language changes
    @Environment(\.locale) var locale
    
    var isArabic: Bool {
        locale.language.languageCode?.identifier == "ar"
    }
    
    func body(content: Content) -> some View {
        content
            .font(.custom(weight.name(isArabic: isArabic), size: style.size))
    }
}

// MARK: - View Extension
extension View {
    /// Applies the Carely Design System typography to a View.
    /// This modifier is fully reactive to in-app language changes.
    func carelyText(style: CarelyTextStyle, weight: CarelyFontWeight = .regular) -> some View {
        self.modifier(CarelyTypographyModifier(style: style, weight: weight))
    }
}

/*
// MARK: - HOW TO USE
// Place this anywhere in your SwiftUI Views to maintain design consistency.
// NOTE: Always use the `.carelyText` modifier to ensure the font updates
// instantly if the user changes the language inside the app.

// Example 1: Using the Light weight
Text("Subtle caption text")
    .carelyText(style: .caption, weight: .light)

// Example 2: Using the Default Regular weight
Text("Standard body description")
    .carelyText(style: .bodyRegular)

// Example 3: Using the Medium weight
Text("Section Title")
    .carelyText(style: .heading3, weight: .medium)
*/
