//
//  GetGreetingNameUseCase.swift
//  Carely
//
//  Created by Mina on 22/07/2026.
//

import Foundation
 
protocol GetGreetingNameUseCaseProtocol {
    func execute() async throws -> String
}
 
final class GetGreetingNameUseCase: GetGreetingNameUseCaseProtocol {
    private let repository: HomeRepositoryProtocol
 
    init(repository: HomeRepositoryProtocol) {
        self.repository = repository
    }
 
    func execute() async throws -> String {
        try await repository.fetchGreetingName()
    }
}
