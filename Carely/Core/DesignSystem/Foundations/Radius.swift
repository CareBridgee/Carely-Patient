//
//  IconSize.swift
//  Carely
//
//  Created by Mohamed Ayman on 17/07/2026.
//

import SwiftUI

public enum Radius {

    public static let r0: CGFloat = 0
    public static let r4: CGFloat = 4
    public static let r8: CGFloat = 8
    public static let r12: CGFloat = 12
    public static let r16: CGFloat = 16
    public static let r20: CGFloat = 20
    public static let r24: CGFloat = 24
    public static let r28: CGFloat = 28
    public static let r32: CGFloat = 32

    public static let pill: CGFloat = .greatestFiniteMagnitude
}

// MARK: - RoundedRectangle Convenience

public extension RoundedRectangle {
    static func carely(_ radius: CGFloat) -> RoundedRectangle {
        RoundedRectangle(cornerRadius: radius, style: .continuous)
    }
}
