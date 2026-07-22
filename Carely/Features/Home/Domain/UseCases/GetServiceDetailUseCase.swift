//
//  GetServiceDetailUseCase.swift
//  Carely
//
//  Created by Mina on 22/07/2026.
//

import Foundation
 
protocol GetServiceDetailUseCaseProtocol {
    func execute(id: String) async throws -> ServiceDetail
}
 
final class GetServiceDetailUseCase: GetServiceDetailUseCaseProtocol {
    private let repository: HomeRepositoryProtocol
 
    init(repository: HomeRepositoryProtocol) {
        self.repository = repository
    }
 
    func execute(id: String) async throws -> ServiceDetail {
        try await repository.fetchServiceDetail(id: id)
    }
}
