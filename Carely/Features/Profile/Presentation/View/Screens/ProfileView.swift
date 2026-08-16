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

                    if viewModel.isLoading && viewModel.profile == nil {
                        profileSkeletonView
                    } else if let profile = viewModel.profile {
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
        }
        .navigationBarHidden(true)
        .onAppear { viewModel.onAppear() }
        .alert("Log Out?", isPresented: $viewModel.showLogoutConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Log Out", role: .destructive) {
                viewModel.confirmLogout()
            }
        } message: {
            Text("Are you sure you want to log out of your account?")
        }

        .errorToast($viewModel.errorMessage)
    }

    private var profileSkeletonView: some View {
        VStack(spacing: Spacing.s24) {
            VStack(spacing: Spacing.s12) {
                EtmaenSkeletonCircle(size: 88)
                EtmaenSkeletonRect(width: 160, height: 20, radius: Radius.r8)
                EtmaenSkeletonRect(width: 100, height: 14, radius: Radius.r8)
            }
            .frame(maxWidth: .infinity)
            .padding(.top, Spacing.s16)

            VStack(spacing: Spacing.s12) {
                ForEach(0..<4, id: \.self) { _ in
                    EtmaenCardSkeleton(height: 64)
                }
            }
        }
    }

    private func profileHeader(_ profile: PatientProfile) -> some View {
        VStack(spacing: Spacing.s12) {
            ZStack(alignment: .bottomTrailing) {
                // Avatar — remote image or fallback icon
                Group {
                    if let url = viewModel.profileImageUrl {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 96, height: 96)
                                    .clipped()
                            case .empty:
                                Circle()
                                    .fill(Color.surfaceVariant)
                                    .overlay(
                                        ProgressView()
                                            .tint(Color.brandPrimary)
                                    )
                                    .frame(width: 96, height: 96)
                            case .failure:
                                fallbackAvatar
                            @unknown default:
                                fallbackAvatar
                            }
                        }
                        .frame(width: 96, height: 96)
                    } else {
                        fallbackAvatar
                    }
                }
                .frame(width: 96, height: 96)
                .clipShape(Circle())
            }

            VStack(spacing: Spacing.s4) {
                Text(profile.displayName)
                    .carelyText(style: .heading3, weight: .bold)
                    .foregroundColor(.primaryFont)
                Text(profile.roleText)
                    .carelyText(style: .bodySmall)
                    .foregroundColor(.secondaryFont)
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var fallbackAvatar: some View {
        Circle()
            .fill(Color.tint.opacity(0.35))
            .overlay(
                Image(systemName: "person.fill")
                    .font(.system(size: 36))
                    .foregroundColor(.brandPrimary)
            )
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
