//
//  FamilyMemberCard.swift
//  Carely
//
//  Created by Mina on 25/07/2026.
//

import SwiftUI

struct FamilyMemberCard: View {
    let member: FamilyMember
    var onRemove: () -> Void = {}
    var onEditPersonalInfo: () -> Void = {}
    var onEditHealthProfile: () -> Void = {}

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.s16) {
            HStack(alignment: .top, spacing: Spacing.s12) {
                Image(systemName: member.avatarIconName)
                    .resizable()
                    .foregroundColor(.brandPrimary)
                    .frame(width: 48, height: 48)
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: Spacing.s4) {
                    Text(member.name)
                        .carelyText(style: .bodyRegular, weight: .semiBold)
                        .foregroundColor(.primaryFont)

                    Text(member.relation)
                        .carelyText(style: .caption, weight: .medium)
                        .foregroundColor(.onPrimaryContainer)
                        .padding(.horizontal, Spacing.s8)
                        .padding(.vertical, 2)
                        .background(Color.primaryContainer)
                        .clipShape(Capsule())
                }

                Spacer()

                Button(action: onRemove) {
                    Image(systemName: "trash")
                        .carelyText(style: .bodyRegular)
                        .foregroundColor(.error)
                        .frame(width: 32, height: 32)
                        .background(Color.errorContainer.opacity(0.5))
                        .clipShape(Circle())
                }
            }

            HStack {
                VStack(alignment: .leading, spacing: Spacing.s4) {
                    Text("Last Checkup")
                        .carelyText(style: .caption)
                        .foregroundColor(.secondaryFont)
                    Text(member.lastCheckupDateText)
                        .carelyText(style: .bodySmall, weight: .medium)
                        .foregroundColor(.primaryFont)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: Spacing.s4) {
                    Text("Upcoming")
                        .carelyText(style: .caption)
                        .foregroundColor(.secondaryFont)
                    Text(member.upcomingCareText)
                        .carelyText(style: .bodySmall, weight: .semiBold)
                        .foregroundColor(.brandPrimary)
                }
            }

            HStack(spacing: Spacing.s12) {
                PrimaryButton(
                    title: "Edit Personal Info",
                    size: .small,
                    action: onEditPersonalInfo
                )
                SecondaryButton(
                    title: "Edit Health Profile",
                    size: .small,
                    action: onEditHealthProfile
                )
            }
        }
        .padding(Spacing.s16)
        .background(Color.surface)
        .clipShape(RoundedRectangle.carely(Radius.r24))
        .carelyShadow(.sm)
    }
}

#Preview {
    FamilyMemberCard(
        member: FamilyMember(
            id: "1",
            name: "Maria Garcia",
            relation: "Mother",
            avatarIconName: "person.crop.circle.fill",
            lastCheckupDateText: "Oct 12, 2023",
            upcomingCareText: "Dental Care"
        )
    )
    .padding()
    .background(Color.backGround)
}
