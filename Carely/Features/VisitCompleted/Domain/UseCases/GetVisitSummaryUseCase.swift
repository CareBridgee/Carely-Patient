//
//  GetVisitSummaryUseCase.swift
//  Carely
//
//  Created by Mina on 24/07/2026.
//

import Foundation
 
protocol GetVisitSummaryUseCaseProtocol {
    func execute(visitId: String) async throws -> VisitSummary
}
 
final class GetVisitSummaryUseCase: GetVisitSummaryUseCaseProtocol {
    private let repository: VisitSummaryRepositoryProtocol
 
    init(repository: VisitSummaryRepositoryProtocol) {
        self.repository = repository
    }
 
    func execute(visitId: String) async throws -> VisitSummary {
        try await repository.fetchVisitSummary(visitId: visitId)
    }
}
