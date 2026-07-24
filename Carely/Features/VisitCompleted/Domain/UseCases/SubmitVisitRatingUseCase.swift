//
//  SubmitVisitRatingUseCase.swift
//  Carely
//
//  Created by Mina on 24/07/2026.
//

import Foundation
 
protocol SubmitVisitRatingUseCaseProtocol {
    func execute(_ rating: VisitRating) async throws
}
 
final class SubmitVisitRatingUseCase: SubmitVisitRatingUseCaseProtocol {
    private let repository: VisitSummaryRepositoryProtocol
 
    init(repository: VisitSummaryRepositoryProtocol) {
        self.repository = repository
    }
 
    func execute(_ rating: VisitRating) async throws {
        try await repository.submitVisitRating(rating)
    }
}
