//
//  FamilyMembersViewModel.swift
//  Carely
//
//  Created by Mina on 25/07/2026.
//

import Foundation
import Combine

@MainActor
final class FamilyMembersViewModel: ObservableObject {
    @Published var members: [FamilyMember] = []
    private var storeCancellables = Set<AnyCancellable>()

    @Published var isLoading: Bool = false

    /// Drives the `.errorToast` for load and delete failures. Always the
    /// exact server message (via `error.carelyDescription`) rather than a
    /// hardcoded fallback string.
    @Published var errorMessage: String? = nil

    @Published var deletingMemberId: String? = nil   // shows per-row spinner
    private let getFamilyMembersUseCase: GetFamilyMembersUseCaseProtocol
    private let deleteProfileUseCase: DeleteProfileUseCaseProtocol
    private let patientProfilesStore: PatientProfilesStore
    private let coordinator: ProfileCoordinator

    init(
        getFamilyMembersUseCase: GetFamilyMembersUseCaseProtocol,
        deleteProfileUseCase: DeleteProfileUseCaseProtocol,
        patientProfilesStore: PatientProfilesStore,
        coordinator: ProfileCoordinator
    ) {
        self.getFamilyMembersUseCase  = getFamilyMembersUseCase
        self.deleteProfileUseCase     = deleteProfileUseCase
        self.patientProfilesStore     = patientProfilesStore
        self.coordinator              = coordinator
        bindToStore()
    }

    private func bindToStore() {
        patientProfilesStore.$familyMembers
            .receive(on: DispatchQueue.main)
            .assign(to: &$members)
    }

    func onAppear() {
        if members.isEmpty {
            loadMembers()
        }
    }

    func refreshMembers() {
        loadMembers()
    }

    func loadMembers() {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                _ = try await self.getFamilyMembersUseCase.execute()
                self.isLoading = false
            } catch {
                self.isLoading = false
                self.errorMessage = error.carelyDescription
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

    @Published var memberToDelete: FamilyMember? = nil
    @Published var showDeleteConfirmation: Bool = false

    func removeMemberTapped(_ member: FamilyMember) {
        memberToDelete = member
        showDeleteConfirmation = true
    }

    func confirmRemoveMember() {
        guard let member = memberToDelete else { return }
        memberToDelete = nil

        // Optimistic: remove from list immediately
        members.removeAll { $0.id == member.id }

        Task {
            do {
                try await deleteProfileUseCase.execute(id: member.id)
            } catch {
                // Restore member on failure
                members.append(member)
                members.sort { $0.name < $1.name }
                errorMessage = error.carelyDescription
            }
        }
    }
}
