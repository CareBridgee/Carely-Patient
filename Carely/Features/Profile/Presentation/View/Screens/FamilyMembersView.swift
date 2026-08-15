//
//  FamilyMembersView.swift
//  Carely
//
//  Created by Mina on 25/07/2026.
//

import SwiftUI

struct FamilyMembersView: View {
    @StateObject private var viewModel: FamilyMembersViewModel

    init(viewModel: FamilyMembersViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            Color.backGround.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: Spacing.s20) {
                    header

                    if viewModel.isLoading && viewModel.members.isEmpty {
                        VStack(spacing: Spacing.s16) {
                            ForEach(0..<3, id: \.self) { _ in
                                VStack(alignment: .leading, spacing: Spacing.s16) {
                                    HStack(spacing: Spacing.s12) {
                                        EtmaenSkeletonCircle(size: 52)
                                        VStack(alignment: .leading, spacing: Spacing.s4) {
                                            EtmaenSkeletonRect(width: 130, height: 16, radius: Radius.r8)
                                            EtmaenSkeletonRect(width: 70, height: 18, radius: Radius.r12)
                                        }
                                        Spacer()
                                    }
                                    HStack(spacing: Spacing.s8) {
                                        EtmaenSkeletonRect(height: 36, radius: Radius.r12)
                                        EtmaenSkeletonRect(height: 36, radius: Radius.r12)
                                    }
                                }
                                .padding(Spacing.s16)
                                .background(Color.surface)
                                .clipShape(RoundedRectangle.carely(Radius.r24))
                                .carelyShadow(.sm)
                            }
                        }
                    } else {
                        VStack(spacing: Spacing.s16) {
                            ForEach(viewModel.members) { member in
                                FamilyMemberCard(
                                    member: member,
                                    onRemove: { viewModel.removeMemberTapped(member) },
                                    onEditPersonalInfo: { viewModel.editPersonalInfoTapped(for: member) },
                                    onEditHealthProfile: { viewModel.editHealthProfileTapped(for: member) }
                                )
                            }

                            AddFamilyMemberCard(action: viewModel.addFamilyMemberTapped)
                        }
                    }
                }
                .padding(Spacing.s16)
                .padding(.bottom, Spacing.s32)
            }
        }
        .careConnectNavigationBar(
            title: "Family Members",
            showBackButton: true,
            onBackTapped: {
                viewModel.backTapped()
            }
        )
        .onAppear { viewModel.onAppear() }
        .alert("Remove Family Member", isPresented: $viewModel.showDeleteConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Remove", role: .destructive) {
                viewModel.confirmRemoveMember()
            }
        } message: {
            Text("Are you sure you want to remove \(viewModel.memberToDelete?.name ?? "this family member")? This action cannot be undone.")
        }
        .alert("Something went wrong", isPresented: $viewModel.showError) {
            Button("Retry") { viewModel.loadMembers() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "Please try again.")
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: Spacing.s4) {
            Text("Family Members")
                .carelyText(style: .heading2, weight: .bold)
                .foregroundColor(.primaryFont)
            Text("Manage healthcare profiles for your loved ones.")
                .carelyText(style: .bodySmall)
                .foregroundColor(.secondaryFont)
        }
    }
}
