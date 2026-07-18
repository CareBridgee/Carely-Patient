//
//  StepProgressHeader.swift
//  Carely
//
//  Created by Mohamed Ayman on 18/07/2026.
//

import SwiftUI

struct StepProgressHeader: View {
    let currentStep: Int
    let totalSteps: Int
    let stepTitle: String
    
    private var isCompleted: Bool {
        currentStep >= totalSteps && totalSteps > 0
    }
    
    private var progressWidthMultiplier: CGFloat {
        guard totalSteps > 0 else { return 0 }
        return CGFloat(min(currentStep, totalSteps)) / CGFloat(totalSteps)
    }
    
    var body: some View {
        VStack(spacing: Spacing.s8) {
            HStack {
                Text("Step \(currentStep) of \(totalSteps)")
                    .carelyText(style: .bodySmall, weight: .bold)
                    .foregroundColor(isCompleted ? .primary.opacity(0.6) : .primary)
                
                Spacer()
                
                Text(stepTitle)
                    .carelyText(style: .bodySmall, weight: .medium)
                    .foregroundColor(.secondaryFont)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle.trueFit(Radius.pill)
                        .fill(Color.track)
                        .frame(height: 6)
                    
                    RoundedRectangle.trueFit(Radius.pill)
                        .fill(isCompleted ? Color.success : Color.primary)
                        .frame(width: geometry.size.width * progressWidthMultiplier, height: 6)
                }
            }
            .frame(height: 6)
        }
    }
}

#Preview("Step Progress Header States") {
    VStack(spacing: Spacing.s24) {
        StepProgressHeader(currentStep: 7, totalSteps: 8, stepTitle: "Allergies")
        
        StepProgressHeader(currentStep: 8, totalSteps: 8, stepTitle: "Review")
    }
    .padding(Spacing.s16)
    .background(Color.backGround)
}
