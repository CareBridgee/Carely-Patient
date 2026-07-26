//
//  ProfileView.swift
//  Carely
//
//  Created by Mina on 25/07/2026.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel: ProfileViewModel

    init(viewModel: ProfileViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            Color.backGround.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: Spacing.s24) {

                    if let profile = viewModel.profile {
                        profileHeader(profile)

                        VStack(spacing: Spacing.s12) {
                            ForEach(viewModel.menuRows) { row in
                                ProfileMenuRow(data: row) {
                                    viewModel.menuRowTapped(row.item)
                                }
                            }
                        }

                        logoutButton

                        Text(profile.appVersionText)
                            .carelyText(style: .caption)
                            .foregroundColor(.hint)
                            .frame(maxWidth: .infinity)
                            .padding(.top, Spacing.s8)
                    }
                }
                .padding(Spacing.s16)
                .padding(.bottom, Spacing.s32)
            }

            if viewModel.isLoading && viewModel.profile == nil {
                ProgressView()
            }
        }
        .navigationBarHidden(true)
        .onAppear { viewModel.onAppear() }
        .alert("Something went wrong", isPresented: $viewModel.showError) {
            Button("Retry") { viewModel.loadProfile() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "Please try again.")
        }
    }

    private func profileHeader(_ profile: PatientProfile) -> some View {
        VStack(spacing: Spacing.s12) {
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(Color.tint.opacity(0.35))
                    .frame(width: 96, height: 96)
                    .overlay(
                        Image(systemName: profile.avatarIconName)
                            .font(.system(size: 36))
                            .foregroundColor(.brandPrimary)
                    )

                Circle()
                    .fill(Color.brandPrimary)
                    .frame(width: 30, height: 30)
                    .overlay(
                        Image(systemName: "pencil")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.onPrimary)
                    )
            }

            VStack(spacing: Spacing.s4) {
                Text(profile.name)
                    .carelyText(style: .heading3, weight: .bold)
                    .foregroundColor(.primaryFont)
                Text(profile.role)
                    .carelyText(style: .bodySmall)
                    .foregroundColor(.secondaryFont)
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var logoutButton: some View {
        Button(action: viewModel.logoutTapped) {
            HStack(spacing: Spacing.s12) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.system(size: 16))
                Text("Logout")
                    .carelyText(style: .bodyRegular, weight: .semiBold)
            }
            .foregroundColor(.error)
            .frame(maxWidth: .infinity)
            .padding(Spacing.s16)
            .background(Color.errorContainer.opacity(0.5))
            .clipShape(RoundedRectangle.carely(Radius.r20))
        }
        .buttonStyle(.plain)
    }
}

//#Preview {
//    let repository = ProfileRepositoryImpl()
//    ProfileView(
//        viewModel: ProfileViewModel(
//            getPatientProfileUseCase: GetPatientProfileUseCase(repository: repository),
//            getFamilyMembersUseCase: GetFamilyMembersUseCase(repository: repository),
//            coordinator: ProfileCoordinator()
//        )
//    )
//}
