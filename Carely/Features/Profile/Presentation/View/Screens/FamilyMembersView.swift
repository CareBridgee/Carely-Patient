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
                VStack(alignment: .leading, spacing: Spacing.s24) {

                    topBar

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

                        addFamilyMemberButton
                    }
                }
                .padding(Spacing.s16)
                .padding(.bottom, Spacing.s32)
            }

            if viewModel.isLoading && viewModel.members.isEmpty {
                ProgressView()
            }
        }
        .navigationBarHidden(true)
        .onAppear { viewModel.onAppear() }
        .alert("Something went wrong", isPresented: $viewModel.showError) {
            Button("Retry") { viewModel.loadMembers() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "Please try again.")
        }
    }

    private var topBar: some View {
        HStack {
            Button(action: viewModel.backTapped) {
                Image(systemName: "arrow.left")
                    .carelyText(style: .bodyLarge, weight: .semiBold)
                    .foregroundColor(.brandPrimary)
                    .frame(width: 40, height: 40)
                    .background(Color.surface)
                    .clipShape(Circle())
            }

            Spacer()

            Text("Family Members")
                .carelyText(style: .heading3, weight: .semiBold)
                .foregroundColor(.brandPrimary)

            Spacer()

            Color.clear.frame(width: 40, height: 40)
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

    private var addFamilyMemberButton: some View {
        Button(action: viewModel.addFamilyMemberTapped) {
            VStack(spacing: Spacing.s12) {
                Circle()
                    .fill(Color.brandPrimary)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: "person.badge.plus")
                            .font(.system(size: 16))
                            .foregroundColor(.onPrimary)
                    )

                Text("Add Family Member")
                    .carelyText(style: .bodyRegular, weight: .semiBold)
                    .foregroundColor(.brandPrimary)
            }
            .frame(maxWidth: .infinity)
            .padding(Spacing.s24)
            .background(Color.mintSurface.opacity(0.5))
            .clipShape(RoundedRectangle.carely(Radius.r24))
            .overlay(
                RoundedRectangle.carely(Radius.r24)
                    .stroke(style: StrokeStyle(lineWidth: 1.5, dash: [6, 5]))
                    .foregroundColor(.brandPrimary.opacity(0.5))
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    FamilyMembersView(
        viewModel: FamilyMembersViewModel(
            getFamilyMembersUseCase: GetFamilyMembersUseCase(repository: ProfileRepositoryImpl()),
            coordinator: ProfileCoordinator()
        )
    )
}
