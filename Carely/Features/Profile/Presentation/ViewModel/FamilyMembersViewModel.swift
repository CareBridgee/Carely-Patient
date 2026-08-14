//
//  FamilyMembersViewModel.swift
//  Carely
//
//  Created by Mina on 25/07/2026.
//

import Foundation

@MainActor
final class FamilyMembersViewModel: ObservableObject {

    @Published var members: [FamilyMember] = []

    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var showError: Bool = false

    @Published var deletingMemberId: String? = nil   // shows per-row spinner

    private let getFamilyMembersUseCase: GetFamilyMembersUseCaseProtocol
    private let profileNetworkService: ProfileNetworkServiceProtocol
    private let coordinator: ProfileCoordinator

    init(
        getFamilyMembersUseCase: GetFamilyMembersUseCaseProtocol,
        profileNetworkService: ProfileNetworkServiceProtocol,
        coordinator: ProfileCoordinator
    ) {
        self.getFamilyMembersUseCase  = getFamilyMembersUseCase
        self.profileNetworkService    = profileNetworkService
        self.coordinator              = coordinator
    }

    func onAppear() {
        guard members.isEmpty else { return }
        loadMembers()
    }

    func refreshMembers() {
        members = []
        loadMembers()
    }

    func loadMembers() {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let fetched = try await getFamilyMembersUseCase.execute()
                self.members = fetched
                self.isLoading = false
            } catch {
                self.isLoading = false
                self.errorMessage = error.localizedDescription
                self.showError = true
            }
        }
    }

    // MARK: - Navigation

    func backTapped() {
        coordinator.pop()
    }

    func editPersonalInfoTapped(for member: FamilyMember) {
        coordinator.push(.editMemberPersonalInfo(profileId: member.id))
    }

    func editHealthProfileTapped(for member: FamilyMember) {
        coordinator.push(.editMemberHealthProfile(profileId: member.id))
    }

    func editAddressTapped(for member: FamilyMember) {
        coordinator.push(.address(profileId: member.id))
    }

    func addFamilyMemberTapped() {
        coordinator.addFamilyMemberTapped()
    }

    // MARK: - Remove Member

    func removeMemberTapped(_ member: FamilyMember) {
        // Optimistic: remove from list immediately
        members.removeAll { $0.id == member.id }

        Task {
            do {
                try await profileNetworkService.deleteProfile(id: member.id)
            } catch {
                // Restore member on failure
                members.append(member)
                members.sort { $0.name < $1.name }
                errorMessage = "Couldn't remove member. Please try again."
                showError = true
            }
        }
    }
}
