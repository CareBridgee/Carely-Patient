//
//  FlowLayout.swift
//  Carely
//
//  Created by Mina on 20/07/2026.
//

import SwiftUI
 
struct FlowLayout: Layout {
    var spacing: CGFloat = Spacing.s8
    var lineSpacing: CGFloat = Spacing.s8
 
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        var currentRowWidth: CGFloat = 0
        var currentRowHeight: CGFloat = 0
        var totalHeight: CGFloat = 0
        var measuredWidth: CGFloat = 0
 
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
 
            if currentRowWidth > 0, currentRowWidth + spacing + size.width > maxWidth {
                totalHeight += currentRowHeight + lineSpacing
                measuredWidth = max(measuredWidth, currentRowWidth)
                currentRowWidth = 0
                currentRowHeight = 0
            }
 
            currentRowWidth += (currentRowWidth > 0 ? spacing : 0) + size.width
            currentRowHeight = max(currentRowHeight, size.height)
        }
 
        totalHeight += currentRowHeight
        measuredWidth = max(measuredWidth, currentRowWidth)
 
        return CGSize(
            width: maxWidth.isFinite ? maxWidth : measuredWidth,
            height: totalHeight
        )
    }
 
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x: CGFloat = bounds.minX
        var y: CGFloat = bounds.minY
        var currentRowHeight: CGFloat = 0
 
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
 
            if x > bounds.minX, x + size.width > bounds.minX + bounds.width {
                x = bounds.minX
                y += currentRowHeight + lineSpacing
                currentRowHeight = 0
            }
 
            subview.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
            x += size.width + spacing
            currentRowHeight = max(currentRowHeight, size.height)
        }
    }
}
