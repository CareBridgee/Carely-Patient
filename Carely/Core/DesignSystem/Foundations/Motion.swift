//
//  Motion.swift
//  Carely Design System
//
//  Carely motion constants for direct use in animations.
//

import SwiftUI

public enum CarelyMotion {

    /// 200ms — UI transitions (chip selection, tab switch)
    public static let durationFast: Double = 0.2

    /// 300ms — Screen transitions
    public static let durationStandard: Double = 0.3

    /// Default spring — chip selection, tab switch indicator
    /// response: 0.4, damping: 0.8
    public static let springDefault: Animation = .spring(response: 0.4, dampingFraction: 0.8)

    /// Snappy spring — button press scale, heart tap
    /// response: 0.25, damping: 0.7
    public static let springSnappy: Animation = .spring(response: 0.25, dampingFraction: 0.7)

    /// Card entrance stagger delay per item
    public static let staggerDelay: Double = 0.04

    /// Loading animation cycle duration
    public static let loadingCycle: Double = 0.9
}
