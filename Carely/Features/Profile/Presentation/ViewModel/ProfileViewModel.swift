//
//  ProfileViewModel.swift
//  Carely
//
//  Created by Mina on 25/07/2026.
//

import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {

    @Published var profile: PatientProfile?
    @Published var menuRows: [ProfileMenuRowData] = []

    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var showError: Bool = false

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

    init(
        getPatientProfileUseCase: GetPatientProfileUseCaseProtocol,
        getFamilyMembersUseCase: GetFamilyMembersUseCaseProtocol,
        logoutUseCase: LogoutUseCaseProtocol,
        coordinator: ProfileCoordinator,
        sessionManager: SessionManager
    ) {
        self.getPatientProfileUseCase = getPatientProfileUseCase
        self.getFamilyMembersUseCase = getFamilyMembersUseCase
        self.logoutUseCase = logoutUseCase
        self.coordinator = coordinator
        self.sessionManager = sessionManager
    }

    func onAppear() {
        guard profile == nil else { return }
        loadProfile()
    }

    func loadProfile() {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                async let profile = getPatientProfileUseCase.execute()
                async let members = getFamilyMembersUseCase.execute()

                let (fetchedProfile, fetchedMembers) = try await (profile, members)

                self.profile = fetchedProfile
                self.menuRows = Self.makeMenuRows(activeFamilyMembersCount: fetchedMembers.count)
                self.isLoading = false
            } catch {
                self.isLoading = false
                self.errorMessage = error.localizedDescription
                self.showError = true
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

    func logoutTapped() {
        Task {
            isLoading = true
            do {
                try await logoutUseCase.execute()
                coordinator.logoutTapped()
            } catch {
                isLoading = false
                errorMessage = "Failed to logout: \(error.localizedDescription)"
                showError = true
            }
        }
    }
}
