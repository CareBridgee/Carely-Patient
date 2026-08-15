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
    @Published var errorMessage: String?
    @Published var showError = false

    private let nurseId: String
    private let getNurseProfileUseCase: GetNurseProfileUseCaseProtocol

    init(nurseId: String, getNurseProfileUseCase: GetNurseProfileUseCaseProtocol) {
        self.nurseId = nurseId
        self.getNurseProfileUseCase = getNurseProfileUseCase
    }

    func fetchProfile() {
        guard profile == nil else { return }
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let fetched = try await self.getNurseProfileUseCase.execute(nurseId: self.nurseId)
                self.profile = fetched
                self.isLoading = false
            } catch {
                self.isLoading = false
                self.errorMessage = error.localizedDescription
                self.showError = true
            }
        }
    }
}
