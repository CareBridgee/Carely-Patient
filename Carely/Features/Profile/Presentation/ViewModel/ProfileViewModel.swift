//
//  ProfileViewModel.swift
//  Carely
//
//  Created by Mina on 25/07/2026.
//

import Foundation
import Combine

@MainActor
final class ProfileViewModel: ObservableObject {

    @Published var profile: PatientProfile?
    @Published var menuRows: [ProfileMenuRowData] = []
    private var storeCancellables = Set<AnyCancellable>()

    @Published var isLoading: Bool = false

    /// Drives the `.errorToast` for both profile-fetch and logout failures,
    /// per the doc's instructions for this screen.
    @Published var errorMessage: String? = nil

    /// Profile image URL — sessionManager cache is the most up-to-date source
    /// (updated immediately on save), API response is the fallback.
    var profileImageUrl: URL? {
        let urlString = sessionManager.currentUser?.profileImageUrl
            ?? profile?.profileImageUrl
        guard let urlString else { return nil }
        return URL(string: urlString)
    }

    private let getPatientProfileUseCase: GetPatientProfileUseCaseProtocol
    private let getFamilyMembersUseCase: GetFamilyMembersUseCaseProtocol
    private let logoutUseCase: LogoutUseCaseProtocol
    private let coordinator: ProfileCoordinator
    private let sessionManager: SessionManager
    private let patientProfilesStore: PatientProfilesStore

    init(
        getPatientProfileUseCase: GetPatientProfileUseCaseProtocol,
        getFamilyMembersUseCase: GetFamilyMembersUseCaseProtocol,
        logoutUseCase: LogoutUseCaseProtocol,
        coordinator: ProfileCoordinator,
        sessionManager: SessionManager,
        patientProfilesStore: PatientProfilesStore
    ) {
        self.getPatientProfileUseCase = getPatientProfileUseCase
        self.getFamilyMembersUseCase = getFamilyMembersUseCase
        self.logoutUseCase = logoutUseCase
        self.coordinator = coordinator
        self.sessionManager = sessionManager
        self.patientProfilesStore = patientProfilesStore
        bindToStore()
    }

    func onAppear() {
        if profile == nil {
            loadProfile()
        }
    }

    private func bindToStore() {
        patientProfilesStore.$primaryProfile
            .receive(on: DispatchQueue.main)
            .assign(to: &$profile)

        patientProfilesStore.$familyMembers
            .receive(on: DispatchQueue.main)
            .sink { [weak self] members in
                self?.menuRows = Self.makeMenuRows(activeFamilyMembersCount: members.count)
            }
            .store(in: &storeCancellables)
    }

    func loadProfile() {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                async let profile = self.getPatientProfileUseCase.execute()
                async let family = self.getFamilyMembersUseCase.execute()
                _ = try await (profile, family)
                self.isLoading = false
            } catch {
                self.isLoading = false
                self.errorMessage = error.carelyDescription
            }
        }
    }

    private static func makeMenuRows(activeFamilyMembersCount: Int) -> [ProfileMenuRowData] {
        [
            ProfileMenuRowData(item: .personalInfo, subtitle: "Update your account details"),
            ProfileMenuRowData(item: .healthProfile, subtitle: "Medical history & documents"),
            ProfileMenuRowData(item: .familyMembers, subtitle: "Manage dependents (\(activeFamilyMembersCount) active)"),
            ProfileMenuRowData(item: .addresses, subtitle: "Home and care locations"),
            ProfileMenuRowData(item: .payment, subtitle: "Visa ending in ••42"),
            ProfileMenuRowData(item: .settings, subtitle: "Security & App preferences")
        ]
    }

    // MARK: - Navigation

    func menuRowTapped(_ item: ProfileMenuItem) {
        switch item {
        case .personalInfo:
            guard let id = profile?.id else { return }
            coordinator.push(.personalInfo(profileId: id))
        case .healthProfile:
            guard let id = profile?.id else { return }
            coordinator.push(.healthProfile(profileId: id))
        case .familyMembers:
            coordinator.push(.familyMembers)
        case .addresses:
            guard let id = profile?.id else { return }
            coordinator.push(.address(profileId: id))
        case .settings:
            coordinator.push(.settings)
        case .payment:
            break
        }
    }

    @Published var showLogoutConfirmation: Bool = false

    func logoutTapped() {
        showLogoutConfirmation = true
    }

    func confirmLogout() {
        Task {
            isLoading = true
            errorMessage = nil
            do {
                try await logoutUseCase.execute()
                coordinator.logoutTapped()
            } catch {
                isLoading = false
                errorMessage = error.carelyDescription
            }
        }
    }
}
