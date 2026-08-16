//
//  NurseProfileViewModel.swift
//  Carely
//
//  Created by Mina on 08/08/2026.
//

import Foundation

@MainActor
final class NurseProfileViewModel: ObservableObject {
    @Published private(set) var profile: NurseDetails?
    @Published var isLoading = false

    /// Drives the full-page `ErrorStateView` when the nurse details fetch
    /// fails. There's no partial state for this screen — either the profile
    /// loads or it doesn't — so a full-page state with retry fits both the
    /// initial load and any subsequent retry.
    @Published var loadError: Error?

    private let nurseId: String
    private let getNurseProfileUseCase: GetNurseProfileUseCaseProtocol

    init(nurseId: String, getNurseProfileUseCase: GetNurseProfileUseCaseProtocol) {
        self.nurseId = nurseId
        self.getNurseProfileUseCase = getNurseProfileUseCase
    }

    func fetchProfile() {
        guard profile == nil else { return }
        isLoading = true
        loadError = nil

        Task {
            do {
                let fetched = try await self.getNurseProfileUseCase.execute(nurseId: self.nurseId)
                self.profile = fetched
                self.isLoading = false
            } catch {
                self.isLoading = false
                self.loadError = error
            }
        }
    }
}
