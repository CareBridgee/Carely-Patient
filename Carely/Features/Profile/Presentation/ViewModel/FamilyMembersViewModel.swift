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

    private let getFamilyMembersUseCase: GetFamilyMembersUseCaseProtocol
    private let coordinator: ProfileCoordinator

    init(
        getFamilyMembersUseCase: GetFamilyMembersUseCaseProtocol,
        coordinator: ProfileCoordinator
    ) {
        self.getFamilyMembersUseCase = getFamilyMembersUseCase
        self.coordinator = coordinator
    }

    func onAppear() {
        guard members.isEmpty else { return }
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
        //
    }

    func editHealthProfileTapped(for member: FamilyMember) {
        //
    }

    func removeMemberTapped(_ member: FamilyMember) {
        members.removeAll { $0.id == member.id }
    }

    func addFamilyMemberTapped() {
        //
    }
}
