//
//  WalletViewModel.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 16/08/2026.
//




import Foundation
import Combine

@MainActor
final class WalletViewModel: ObservableObject {

    @Published var balance: Double = 0.0
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published private(set) var currentUserId: String? = nil

    private let getWalletSummaryUseCase: GetWalletSummaryUseCaseProtocol
    private let coordinator: ProfileCoordinator

    init(getWalletSummaryUseCase: GetWalletSummaryUseCaseProtocol, coordinator: ProfileCoordinator) {
        self.getWalletSummaryUseCase = getWalletSummaryUseCase
        self.coordinator = coordinator
    }

    /// Always re-fetches from the server — this is deliberate. After a
    /// top-up, popping back here shows the server's real balance rather
    /// than trusting a locally-held number.
    func onAppear() {
        loadWallet()
    }

    func loadWallet() {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let summary = try await getWalletSummaryUseCase.execute()
                self.currentUserId = summary.userId
                self.balance = summary.balance
                self.isLoading = false
            } catch {
                self.isLoading = false
                self.errorMessage = error.carelyDescription
            }
        }
    }

    func addFundsTapped() {
        guard let userId = currentUserId else {
            errorMessage = WalletError.missingUserId.errorDescription
            return
        }
        coordinator.push(.topUp(userId: userId))
    }
}
