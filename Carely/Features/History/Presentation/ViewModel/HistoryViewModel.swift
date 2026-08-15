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
    @Published var errorMessage: String? = nil
    @Published var showError: Bool = false
 
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
        errorMessage = nil
 
        Task {
            do {
                let fetched = try await self.getHistoryUseCase.execute()
                self.items = fetched
                self.isLoading = false
            } catch {
                self.isLoading = false
                self.errorMessage = error.localizedDescription
                self.showError = true
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
