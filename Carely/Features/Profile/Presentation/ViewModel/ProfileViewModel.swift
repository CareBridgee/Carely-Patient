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

    private let getPatientProfileUseCase: GetPatientProfileUseCaseProtocol
    private let getFamilyMembersUseCase: GetFamilyMembersUseCaseProtocol
    private let coordinator: ProfileCoordinator

    init(
        getPatientProfileUseCase: GetPatientProfileUseCaseProtocol,
        getFamilyMembersUseCase: GetFamilyMembersUseCaseProtocol,
        coordinator: ProfileCoordinator
    ) {
        self.getPatientProfileUseCase = getPatientProfileUseCase
        self.getFamilyMembersUseCase = getFamilyMembersUseCase
        self.coordinator = coordinator
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
        case .familyMembers:
            coordinator.push(.familyMembers)
        case .settings:
            coordinator.push(.settings)
        case .personalInfo, .healthProfile, .addresses, .payment:
            break
        }
    }

    func logoutTapped() {
        coordinator.logoutTapped()
    }
}
