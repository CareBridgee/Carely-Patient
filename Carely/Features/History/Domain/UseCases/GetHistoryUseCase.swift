//
//  GetHistoryUseCase.swift
//  Carely
//
//  Created by Mina on 14/08/2026.
//

import Foundation
 
protocol GetHistoryUseCaseProtocol {
    func execute() async throws -> [VisitHistoryItem]
}
 
final class GetHistoryUseCase: GetHistoryUseCaseProtocol {
    private let repository: HistoryRepositoryProtocol
 
    init(repository: HistoryRepositoryProtocol) {
        self.repository = repository
    }
 
    func execute() async throws -> [VisitHistoryItem] {
        try await repository.fetchHistory()
    }
}
 
