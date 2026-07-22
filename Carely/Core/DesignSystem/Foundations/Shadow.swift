//
//  Shadow.swift
//  Carely Design System
//
//  Apple-style layered 2-shadow technique:
//  a tight dark shadow + a soft wide shadow for refined elevation.
//  Elevation is conveyed via color/shape and shadow, not blur effects.
//

import SwiftUI

// MARK: - Shadow Level

/// Carely shadow elevation levels.
///
/// Each level uses a layered 2-shadow technique (§15 premium improvement):
/// a tight, darker shadow for definition + a soft, wider shadow for depth.
///
/// Usage:
/// ```swift
/// view.carelyShadow(.sm)           // Standard product cards
/// view.carelyShadow(.floating)     // Hero card on blurred blob
/// ```
public enum CarelyShadow: CaseIterable {

    /// Chips, list rows
    case xs

    /// Standard product cards
    case sm

    /// Floating CTA, FAB
    case md

    /// Bottom sheet, modals
    case lg

    /// Hero product card on blob background (brand-colored shadow)
    case floating

    /// Full-screen modal scrim edge
    case modal
}

// MARK: - Shadow Parameters

public extension CarelyShadow {

    /// Primary shadow parameters (tight, defining shadow)
    var primary: ShadowParams {
        switch self {
        case .xs:
            return ShadowParams(color: .black, opacity: 0.06, radius: 2, x: 0, y: 1)
        case .sm:
            return ShadowParams(color: .black, opacity: 0.08, radius: 4, x: 0, y: 2)
        case .md:
            return ShadowParams(color: .black, opacity: 0.10, radius: 8, x: 0, y: 4)
        case .lg:
            return ShadowParams(color: .black, opacity: 0.14, radius: 12, x: 0, y: 8)
        case .floating:
            return ShadowParams(color: .brandPrimary, opacity: 0.18, radius: 10, x: 0, y: 6)
        case .modal:
            return ShadowParams(color: .black, opacity: 0.24, radius: 16, x: 0, y: 12)
        }
    }

    /// Secondary shadow parameters (soft, ambient shadow — layered technique)
    var secondary: ShadowParams {
        switch self {
        case .xs:
            return ShadowParams(color: .black, opacity: 0.03, radius: 4, x: 0, y: 0)
        case .sm:
            return ShadowParams(color: .black, opacity: 0.04, radius: 8, x: 0, y: 0)
        case .md:
            return ShadowParams(color: .black, opacity: 0.06, radius: 16, x: 0, y: 0)
        case .lg:
            return ShadowParams(color: .black, opacity: 0.08, radius: 24, x: 0, y: -2)
        case .floating:
            return ShadowParams(color: .brandPrimary, opacity: 0.10, radius: 20, x: 0, y: -4)
        case .modal:
            return ShadowParams(color: .black, opacity: 0.12, radius: 32, x: 0, y: 0)
        }
    }
}

/// Raw shadow parameters for a single shadow layer.
public struct ShadowParams {
    public let color: Color
    public let opacity: Double
    public let radius: CGFloat
    public let x: CGFloat
    public let y: CGFloat
}

// MARK: - ViewModifier

/// Applies the layered 2-shadow elevation from the Carely shadow system.
public struct CarelyShadowModifier: ViewModifier {
    public let level: CarelyShadow

    public func body(content: Content) -> some View {
        content
            // Layer 1: soft ambient shadow (wider, lighter)
            .shadow(
                color: level.secondary.color.opacity(level.secondary.opacity),
                radius: level.secondary.radius,
                x: level.secondary.x,
                y: level.secondary.y
            )
            // Layer 2: tight defining shadow (sharper, darker)
            .shadow(
                color: level.primary.color.opacity(level.primary.opacity),
                radius: level.primary.radius,
                x: level.primary.x,
                y: level.primary.y
            )
    }
}

public extension View {

    /// Apply a Carely layered shadow elevation.
    ///
    ///     productCard
    ///         .carelyShadow(.sm)
    ///
    func carelyShadow(_ level: CarelyShadow) -> some View {
        modifier(CarelyShadowModifier(level: level))
    }
}
