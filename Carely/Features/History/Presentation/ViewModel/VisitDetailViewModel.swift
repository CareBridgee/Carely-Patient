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
    @Published var errorMessage: String? = nil
    @Published var showError: Bool = false
 
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
        errorMessage = nil
 
        Task {
            do {
                let fetched = try await Task.withMinimumDuration {
                    try await self.getVisitDetailUseCase.execute(id: self.visitId)
                }
                self.detail = fetched
                self.isLoading = false
            } catch {
                self.isLoading = false
                self.errorMessage = error.localizedDescription
                self.showError = true
            }
        }
    }
}
 
