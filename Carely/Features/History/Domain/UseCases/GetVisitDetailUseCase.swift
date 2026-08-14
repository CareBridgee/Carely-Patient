//
//  GetVisitDetailUseCase.swift
//  Carely
//
//  Created by Mina on 14/08/2026.
//

import Foundation
 
protocol GetVisitDetailUseCaseProtocol {
    func execute(id: String) async throws -> VisitDetail
}
 
final class GetVisitDetailUseCase: GetVisitDetailUseCaseProtocol {
    private let repository: HistoryRepositoryProtocol
 
    init(repository: HistoryRepositoryProtocol) {
        self.repository = repository
    }
 
    func execute(id: String) async throws -> VisitDetail {
        try await repository.fetchVisitDetail(id: id)
    }
}
 
