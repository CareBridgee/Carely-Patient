//
//  SearchServiceCategoriesUseCase.swift
//  Carely
//
//  Created by Mina on 22/07/2026.
//

import Foundation
 
protocol SearchServiceCategoriesUseCaseProtocol {
    func execute(query: String) async throws -> [ServiceCategory]
}
 
final class SearchServiceCategoriesUseCase: SearchServiceCategoriesUseCaseProtocol {
    private let repository: HomeRepositoryProtocol
 
    init(repository: HomeRepositoryProtocol) {
        self.repository = repository
    }
 
    func execute(query: String) async throws -> [ServiceCategory] {
        try await repository.searchServiceCategories(query: query)
    }
}
