//
//  SummaryDetailCard.swift
//  Carely
//
//  Created by Mina on 24/07/2026.
//

import SwiftUI
 
struct SummaryDetailCard: View {
    let summary: VisitSummary
 
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.s16) {
            HStack {
                Text("SUMMARY DETAIL")
                    .carelyText(style: .caption, weight: .bold)
                    .foregroundColor(.brandPrimary)
 
                Spacer()
 
                if summary.isVerified {
                    verifiedBadge
                }
            }
 
            Divider()
                .background(Color.divider)
 
            HStack(alignment: .top, spacing: Spacing.s16) {
                SummaryFieldItem(
                    iconName: "briefcase.fill",
                    label: "Medical Professional",
                    value: summary.medicalProfessionalName
                )
                SummaryFieldItem(
                    iconName: "bandage.fill",
                    label: "Service Type",
                    value: summary.serviceType
                )
            }
 
            HStack(alignment: .top, spacing: Spacing.s16) {
                SummaryFieldItem(
                    iconName: "timer",
                    label: "Visit Duration",
                    value: summary.visitDurationText
                )
                SummaryFieldItem(
                    iconName: "calendar",
                    label: "Completed Date",
                    value: summary.completedDateText
                )
            }
        }
        .padding(Spacing.s20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.surface)
        .clipShape(RoundedRectangle.carely(Radius.r24))
        .carelyShadow(.sm)
    }
 
    private var verifiedBadge: some View {
        HStack(spacing: Spacing.s4) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 12))
            Text("Verified Visit")
                .carelyText(style: .caption, weight: .semiBold)
        }
        .foregroundColor(.onSuccessContainer)
        .padding(.horizontal, Spacing.s12)
        .padding(.vertical, Spacing.s4)
        .background(Color.successContainer)
        .clipShape(Capsule())
    }
}
 
private struct SummaryFieldItem: View {
    let iconName: String
    let label: String
    let value: String
 
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.s8) {
            Text(label)
                .carelyText(style: .caption)
                .foregroundColor(.secondaryFont)
 
            HStack(spacing: Spacing.s8) {
                Image(systemName: iconName)
                    .foregroundColor(.brandPrimary)
                Text(value)
                    .carelyText(style: .bodyRegular, weight: .bold)
                    .foregroundColor(.primaryFont)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
 
#Preview {
    SummaryDetailCard(
        summary: VisitSummary(
            id: "1",
            isVerified: true,
            medicalProfessionalName: "Sarah Mitchell",
            serviceType: "Wound Care",
            visitDurationText: "60 mins",
            completedDateText: "Oct 24",
            totalAmountText: "$85.00"
        )
    )
    .padding()
    .background(Color.backGround)
}
 
