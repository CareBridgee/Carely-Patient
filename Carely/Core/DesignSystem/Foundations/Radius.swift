//
//  Radius.swift
//  TrueFit Design System
//
//  Every button, card, chip, and frame uses large radii.
//  "Sharp" is never an option in this system.
//

import SwiftUI

// MARK: - Corner Radius Scale

/// TrueFit corner radius tokens.
///
/// The system defaults to large, friendly radii. Sharp corners
/// are intentionally absent.
///
/// Usage:
/// ```swift
/// .clipShape(RoundedRectangle(cornerRadius: Radius.lg))
/// .cornerRadius(Radius.xl)
/// ```
public enum Radius {

    /// 8pt — Input fields, small tags
    public static let sm: CGFloat = 8

    /// 12pt — Size/variant chips, secondary buttons
    public static let md: CGFloat = 12

    /// 20pt — Standard cards, bottom sheets
    public static let lg: CGFloat = 20

    /// 28pt — Hero/product image frame, primary CTA buttons
    public static let xl: CGFloat = 28

    /// 999pt — "Let's Explore" CTA, price badge, status badges (full capsule)
    public static let pill: CGFloat = 999

    // Note: For circle shapes (avatar, heart icon button, FAB),
    // use `.clipShape(Circle())` instead of a radius value.
}

// MARK: - RoundedRectangle Convenience

public extension RoundedRectangle {

    /// Create a RoundedRectangle with a TrueFit radius token.
    ///
    ///     .clipShape(.trueFit(.lg))
    ///
    static func trueFit(_ radius: CGFloat) -> RoundedRectangle {
        RoundedRectangle(cornerRadius: radius, style: .continuous)
    }
}
