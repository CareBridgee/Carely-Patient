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
    
    /// Dynamically returns the correct font PostScript name based on the app's current language.
    var name: String {
        let isArabic = Locale.current.language.languageCode?.identifier == "ar"
        
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

// MARK: - SwiftUI Font Extension
extension Font {
    /// Generates a custom Carely font using a specific style and weight.
    /// - Parameters:
    ///   - style: The semantic text style (e.g., .heading1, .bodyRegular)
    ///   - weight: The font weight (defaults to .regular)
    /// - Returns: A SwiftUI Font object
    static func carely(_ style: CarelyTextStyle, weight: CarelyFontWeight = .regular) -> Font {
        return .custom(weight.name, size: style.size)
    }
}

// MARK: - Custom View Modifier
struct CarelyTypographyModifier: ViewModifier {
    let style: CarelyTextStyle
    let weight: CarelyFontWeight
    
    func body(content: Content) -> some View {
        content
            .font(.custom(weight.name, size: style.size))
    }
}

extension View {
    /// Applies the Carely Design System typography to a View.
    func carelyText(style: CarelyTextStyle, weight: CarelyFontWeight = .regular) -> some View {
        self.modifier(CarelyTypographyModifier(style: style, weight: weight))
    }
}

/*
// MARK: - HOW TO USE
// Place this anywhere in your SwiftUI Views to maintain design consistency.

// Example 1: Using the Light weight
Text("Subtle caption text")
    .carelyText(style: .caption, weight: .light)

// Example 2: Using the Default Regular weight
Text("Standard body description")
    .carelyText(style: .bodyRegular)

// Example 3: Using the Medium weight via standard Font modifier
Text("Section Title")
    .font(.carely(.heading3, weight: .medium))
*/
