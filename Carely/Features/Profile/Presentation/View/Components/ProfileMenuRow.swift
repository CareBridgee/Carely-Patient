//
//  ProfileMenuRow.swift
//  Carely
//
//  Created by Mina on 25/07/2026.
//

import SwiftUI

struct ProfileMenuRow: View {
    let data: ProfileMenuRowData
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.s16) {
                Image(systemName: data.item.iconName)
                    .carelyText(style: .bodyRegular)
                    .foregroundColor(data.item.isHighlighted ? .onPrimary : .brandPrimary)
                    .frame(width: 44, height: 44)
                    .background(data.item.isHighlighted ? Color.brandPrimary : Color.primaryContainer.opacity(0.5))
                    .clipShape(RoundedRectangle.carely(Radius.r16))

                VStack(alignment: .leading, spacing: Spacing.s4) {
                    Text(data.item.title)
                        .carelyText(style: .bodyRegular, weight: .semiBold)
                        .foregroundColor(.primaryFont)
                    Text(data.subtitle)
                        .carelyText(style: .caption)
                        .foregroundColor(.secondaryFont)
                }

                Spacer(minLength: Spacing.s8)

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.hint)
            }
            .padding(Spacing.s16)
            .background(Color.surface)
            .clipShape(RoundedRectangle.carely(Radius.r20))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack(spacing: Spacing.s12) {
        ProfileMenuRow(data: ProfileMenuRowData(item: .personalInfo, subtitle: "Update your account details"))
        ProfileMenuRow(data: ProfileMenuRowData(item: .healthProfile, subtitle: "Medical history & documents"))
        ProfileMenuRow(data: ProfileMenuRowData(item: .familyMembers, subtitle: "Manage dependents (2 active)"))
    }
    .padding()
    .background(Color.backGround)
}
