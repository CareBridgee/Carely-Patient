//
//  IconSize.swift
//  Carely
//
//  Created by Mohamed Ayman on 17/07/2026.
//

import SwiftUI

public enum Spacing {
    public static let s0: CGFloat = 0
    public static let s2: CGFloat = 2
    public static let s4: CGFloat = 4
    public static let s8: CGFloat = 8
    public static let s12: CGFloat = 12
    public static let s16: CGFloat = 16
    public static let s20: CGFloat = 20
    public static let s24: CGFloat = 24
    public static let s28: CGFloat = 28
    public static let s32: CGFloat = 32
    public static let s40: CGFloat = 40
    public static let s48: CGFloat = 48
    public static let s56: CGFloat = 56
    public static let s64: CGFloat = 64
}

public extension EdgeInsets {
    static func horizontal(_ value: CGFloat, vertical: CGFloat = .zero) -> EdgeInsets {
        EdgeInsets(top: vertical, leading: value, bottom: vertical, trailing: value)
    }

    static func vertical(_ value: CGFloat, horizontal: CGFloat = .zero) -> EdgeInsets {
        EdgeInsets(top: value, leading: horizontal, bottom: value, trailing: horizontal)
    }
}
