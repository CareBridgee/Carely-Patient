//
//  VisitDetailViewModel.swift
//  Carely
//
//  Created by Mina on 14/08/2026.
//

import Foundation
 
@MainActor
final class VisitDetailViewModel: ObservableObject {
 
    let visitId: String
 
    @Published private(set) var detail: VisitDetail?
    @Published var isLoading: Bool = false

    /// Drives the full-page `ErrorStateView` when fetching visit details
    /// fails (there's no cancel action on this screen currently — only a
    /// fetch — so all failures route to the full-page state with retry).
    @Published var loadError: Error? = nil
 
    private let getVisitDetailUseCase: GetVisitDetailUseCaseProtocol
 
    init(visitId: String, getVisitDetailUseCase: GetVisitDetailUseCaseProtocol) {
        self.visitId = visitId
        self.getVisitDetailUseCase = getVisitDetailUseCase
    }
 
    func onAppear() {
        guard detail == nil else { return }
        loadDetail()
    }
 
    func loadDetail() {
        isLoading = true
        loadError = nil
 
        Task {
            do {
                let fetched = try await self.getVisitDetailUseCase.execute(id: self.visitId)
                self.detail = fetched
                self.isLoading = false
            } catch {
                self.isLoading = false
                self.loadError = error
            }
        }
    }
}
