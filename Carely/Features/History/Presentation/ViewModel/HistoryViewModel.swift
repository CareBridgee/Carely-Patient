//
//  HistoryViewModel.swift
//  Carely
//
//  Created by Mina on 14/08/2026.
//

import Foundation
 
@MainActor
final class HistoryViewModel: ObservableObject {
 
    @Published private(set) var items: [VisitHistoryItem] = []
    @Published var isLoading: Bool = false

    /// Drives the full-page `ErrorStateView` with a Retry button when the
    /// visit history fails to load.
    @Published var loadError: Error? = nil
 
    private let getHistoryUseCase: GetHistoryUseCaseProtocol
    private let coordinator: HistoryCoordinator
 
    init(getHistoryUseCase: GetHistoryUseCaseProtocol, coordinator: HistoryCoordinator) {
        self.getHistoryUseCase = getHistoryUseCase
        self.coordinator = coordinator
    }
 
    func onAppear() {
        guard items.isEmpty else { return }
        loadHistory()
    }
 
    func loadHistory() {
        isLoading = true
        loadError = nil
 
        Task {
            do {
                let fetched = try await self.getHistoryUseCase.execute()
                self.items = fetched
                self.isLoading = false
            } catch {
                self.isLoading = false
                self.loadError = error
            }
        }
    }
 
    func itemTapped(_ item: VisitHistoryItem) {
        coordinator.openVisitDetail(id: item.id)
    }
 
    func exploreServicesTapped() {
        coordinator.exploreServicesTapped()
    }

    func backTapped() {
        coordinator.onBackClicked?()
    }
}
