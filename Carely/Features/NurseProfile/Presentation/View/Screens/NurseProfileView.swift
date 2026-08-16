//
//  NurseProfileView.swift
//  Carely
//
//  Created by Mina on 08/08/2026.
//

import SwiftUI

struct NurseProfileView: View {
    @StateObject private var viewModel: NurseProfileViewModel
    @Environment(\.presentationMode) var presentationMode

    init(viewModel: NurseProfileViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            Color.backGround.ignoresSafeArea()

            if viewModel.isLoading {
                nurseProfileSkeletonView
            } else if let profile = viewModel.profile {
                ScrollView {
                    VStack(spacing: Spacing.s24) {
                        NurseProfileHeaderView(profile: profile)
                        NurseProfileServicesView(profile: profile)
                        if !profile.certificates.isEmpty {
                            NurseProfileCertificatesView(profile: profile)
                        }
                        if !profile.personalApproach.isEmpty {
                            NurseProfileApproachView(profile: profile)
                        }
                    }
                    .padding(.horizontal, Spacing.s20)
                    .padding(.bottom, Spacing.s32)
                }
            } else if let loadError = viewModel.loadError {
                ErrorStateView(error: loadError) {
                    viewModel.fetchProfile()
                }
            }
        }
        .careConnectNavigationBar(
            title: "Etmaen",
            onBackTapped: { presentationMode.wrappedValue.dismiss() }
        )
        .onAppear { viewModel.fetchProfile() }
    }

    private var nurseProfileSkeletonView: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: Spacing.s24) {
                // Header & Avatar
                VStack(spacing: Spacing.s16) {
                    EtmaenSkeletonRect(width: 120, height: 120, radius: Spacing.s24)
                        .padding(.top, Spacing.s16)

                    VStack(spacing: Spacing.s4) {
                        EtmaenSkeletonRect(width: 180, height: 20, radius: Radius.r8)
                        EtmaenSkeletonRect(width: 240, height: 16, radius: Radius.r8)
                    }

                    // Stats Pill
                    HStack(spacing: Spacing.s16) {
                        HStack(spacing: Spacing.s8) {
                            EtmaenSkeletonCircle(size: 20)
                            EtmaenSkeletonRect(width: 50, height: 14, radius: Radius.r8)
                        }
                        .frame(maxWidth: .infinity)

                        Divider().frame(height: 30)

                        HStack(spacing: Spacing.s8) {
                            EtmaenSkeletonCircle(size: 20)
                            EtmaenSkeletonRect(width: 50, height: 14, radius: Radius.r8)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.vertical, Spacing.s12)
                    .padding(.horizontal, Spacing.s16)
                    .background(Color.surface)
                    .clipShape(Capsule())
                    .carelyShadow(.sm)
                }

                // Provided Services Section Skeleton
                VStack(alignment: .leading, spacing: Spacing.s12) {
                    EtmaenSkeletonRect(width: 140, height: 18, radius: Radius.r8)

                    HStack(spacing: Spacing.s8) {
                        EtmaenSkeletonRect(width: 90, height: 32, radius: 16)
                        EtmaenSkeletonRect(width: 120, height: 32, radius: 16)
                        EtmaenSkeletonRect(width: 100, height: 32, radius: 16)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                // Approach Section Skeleton
                VStack(alignment: .leading, spacing: Spacing.s12) {
                    EtmaenSkeletonRect(width: 140, height: 18, radius: Radius.r8)

                    VStack(alignment: .leading, spacing: Spacing.s8) {
                        EtmaenSkeletonRect(height: 14, radius: Radius.r8)
                        EtmaenSkeletonRect(height: 14, radius: Radius.r8)
                        EtmaenSkeletonRect(width: 200, height: 14, radius: Radius.r8)
                    }
                    .padding(Spacing.s20)
                    .background(Color.surface)
                    .clipShape(RoundedRectangle.carely(Radius.r16))
                    .carelyShadow(.sm)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, Spacing.s20)
            .padding(.bottom, Spacing.s32)
        }
    }
}

#Preview {
    NurseProfileView(
        viewModel: NurseProfileViewModel(
            nurseId: "3d7c1afa-76ad-4e2a-b91a-3a8ac9854ebf",
            getNurseProfileUseCase: PreviewGetNurseProfileUseCase()
        )
    )
}
private struct PreviewGetNurseProfileUseCase: GetNurseProfileUseCaseProtocol {
    func execute(nurseId: String) async throws -> NurseDetails {
        NurseDetails(
            id: nurseId,
            fullName: "Sarah Mitchell",
            title: "RN",
            specialty: "Specialized Geriatric Care Practitioner",
            profileImageUrl: nil,
            rating: 4.9,
            reviewsCount: 124,
            experienceYears: 12,
            providedServices: [
                "Wound Care",
                "Medication Mgmt",
                "Post-Op Recovery",
                "IV Therapy",
                "Vitals Monitoring"
            ],
            certificates: [
                .init(name: "Nursing License", imageUrl: "https://example.com/license.jpg"),
                .init(name: "Professional Certificate", imageUrl: "https://example.com/cert.jpg")
            ],
            personalApproach: "\"I believe in providing care that respects the dignity and independence of every patient. With over 12 years in hospitals and home care, I focus on clear communication with both patients and their families to ensure a smooth recovery process.\""
        )
    }
}
