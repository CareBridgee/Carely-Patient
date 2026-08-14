//
//  VisitStatusBadge.swift
//  Carely
//
//  Created by Mina on 14/08/2026.
//

import SwiftUI
 
struct VisitStatusBadge: View {
    let status: VisitStatus
 
    var body: some View {
        HStack(spacing: Spacing.s4) {
            Circle()
                .fill(foregroundColor)
                .frame(width: 6, height: 6)
 
            Text(status.displayText.uppercased())
                .carelyText(style: .caption, weight: .semiBold)
                .foregroundColor(foregroundColor)
        }
        .padding(.horizontal, Spacing.s12)
        .padding(.vertical, Spacing.s4)
        .background(backgroundColor)
        .clipShape(Capsule())
    }
 
    private var backgroundColor: Color {
        switch status {
        case .pending: return .warningContainer
        case .confirmed, .accepted, .completed: return .successContainer
        case .inProgress: return .infoContainer
        case .cancelled: return .errorContainer
        case .unknown: return .surfaceVariant
        }
    }
 
    private var foregroundColor: Color {
        switch status {
        case .pending: return .onWarningContainer
        case .confirmed, .accepted, .completed: return .onSuccessContainer
        case .inProgress: return .onInfoContainer
        case .cancelled: return .onErrorContainer
        case .unknown: return .secondaryFont
        }
    }
}
 
