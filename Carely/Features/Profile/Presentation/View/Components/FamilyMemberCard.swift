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

            // Avatar + name row
            HStack(alignment: .center, spacing: Spacing.s12) {
                avatarView
                    .frame(width: 52, height: 52)
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
                        .frame(width: 36, height: 36)
                        .background(Color.errorContainer.opacity(0.5))
                        .clipShape(Circle())
                }
            }

            // Action buttons
            HStack(spacing: Spacing.s8) {
                PrimaryButton(
                    title: "Personal Info",
                    size: .small,
                    action: onEditPersonalInfo
                )
                SecondaryButton(
                    title: "Health Profile",
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

    @ViewBuilder
    private var avatarView: some View {
        if let urlString = member.profileImageUrl,
           let url = URL(string: urlString) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image): image.resizable().scaledToFill()
                default: placeholder
                }
            }
        } else {
            placeholder
        }
    }

    private var placeholder: some View {
        Circle()
            .fill(Color.tint.opacity(0.35))
            .overlay(
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 26))
                    .foregroundColor(.brandPrimary)
            )
    }
}
