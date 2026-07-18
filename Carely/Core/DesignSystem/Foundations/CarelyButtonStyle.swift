//
//  CarelyButtonStyle.swift
//  Carely
//
//  Created by Mohamed Ayman on 18/07/2026.
//

import SwiftUI

 enum CarelyButtonSize {
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

public enum CarelyButtonIconPosition {
    case leading
    case trailing
}
