//
//  PatientSelectorRow.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 22/07/2026.
//


import SwiftUI

struct PatientSelectorRow: View {
    let selected: PatientRelation
    let onSelect: (PatientRelation) -> Void
    let onAddTapped: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.s8) {
            Text("PATIENT")
                .carelyText(style: .caption, weight: .semiBold)
                .foregroundColor(.secondaryFont)

            HStack(spacing: Spacing.s8) {
                ForEach(PatientRelation.allCases) { relation in
                    SecondaryChip(title: relation.title, foreground: .brandPrimary, isSelected: selected == relation)
                        .fixedSize()
                        .onTapGesture { onSelect(relation) }
                }

                Button(action: onAddTapped) {
                    Image(systemName: "plus")
                        .foregroundColor(.hint)
                        .frame(width: Spacing.s32, height: Spacing.s32)
                        .overlay(
                            Circle().strokeBorder(Color.divider, style: StrokeStyle(lineWidth: 1, dash: [3]))
                        )
                }
            }
        }
    }
}
