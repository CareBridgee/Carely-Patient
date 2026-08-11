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
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.brandPrimary))
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
            }
        }
        .careConnectNavigationBar(
            title: "CareConnect",
            onBackTapped: { presentationMode.wrappedValue.dismiss() }
        )
        .onAppear { viewModel.fetchProfile() }
        .alert("Something went wrong", isPresented: $viewModel.showError) {
            Button("Retry") { viewModel.fetchProfile() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "Please try again.")
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
