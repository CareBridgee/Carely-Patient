//
//  Spacing.swift
//  TrueFit Design System
//
//  8pt base grid with a 4pt half-step for tight inline contexts.
//  Strict 8pt scale discipline — no ad hoc 14pt/18pt gaps.
//

import SwiftUI

// MARK: - Spacing Scale

/// TrueFit spacing tokens built on an 8pt base grid.
///
/// Usage:
/// ```swift
/// .padding(.horizontal, Spacing.md)       // 16pt standard margin
/// .spacing(Spacing.xs)                    // 8pt stack gap
/// VStack(spacing: Spacing.lg) { ... }     // 20pt section spacing
/// ```
public enum Spacing {

    /// 4pt — Icon-to-label gaps, chip internal padding
    public static let xxs: CGFloat = 4

    /// 8pt — Stack gap inside tight clusters (rating row, size row)
    public static let xs: CGFloat = 8

    /// 12pt — Card internal padding (compact), button vertical padding
    public static let sm: CGFloat = 12

    /// 16pt — Standard screen horizontal margin; default gap between unrelated elements
    public static let md: CGFloat = 16

    /// 20pt — Card internal padding (standard), section header to content
    public static let lg: CGFloat = 20

    /// 24pt — Gap between major sections on a screen
    public static let xl: CGFloat = 24

    /// 32pt — Hero image to content block gap
    public static let xxl: CGFloat = 32

    /// 40pt — Splash vertical rhythm
    public static let xxxl: CGFloat = 40

    /// 48pt — Top safe-area offset for hero content
    public static let xxxxl: CGFloat = 48

    /// 64pt — Empty-state illustration to text
    public static let xxxxxl: CGFloat = 64

    /// 80pt — Onboarding top whitespace
    public static let xxxxxxl: CGFloat = 80
}
