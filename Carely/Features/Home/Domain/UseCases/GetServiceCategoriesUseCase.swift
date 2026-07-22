//
//  GetServiceCategoriesUseCase.swift
//  Carely
//
//  Created by Mina on 22/07/2026.
//

import Foundation
 
protocol GetServiceCategoriesUseCaseProtocol {
    func execute() async throws -> [ServiceCategory]
}
 
final class GetServiceCategoriesUseCase: GetServiceCategoriesUseCaseProtocol {
    private let repository: HomeRepositoryProtocol
 
    init(repository: HomeRepositoryProtocol) {
        self.repository = repository
    }
 
    func execute() async throws -> [ServiceCategory] {
        try await repository.fetchServiceCategories()
    }
}
