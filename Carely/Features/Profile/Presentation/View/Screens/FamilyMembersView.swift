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
                .padding(Spacing.s16)
                .padding(.bottom, Spacing.s32)
            }

            if viewModel.isLoading && viewModel.members.isEmpty {
                ProgressView()
            }
        }
        .careConnectNavigationBar(
            title: "Family Members",
            showBackButton: true,
            onBackTapped: {
                viewModel.backTapped()
            }
        )
        .blur(radius: viewModel.isLoading ? 3 : 0)
        .onAppear { viewModel.onAppear() }
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
