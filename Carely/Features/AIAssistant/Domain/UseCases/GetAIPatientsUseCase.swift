//
//  GetAIPatientsUseCase.swift
//  Carely
//
//  Created by AI Assistant
//

import Foundation

protocol GetAIPatientsUseCaseProtocol {
    func execute() async throws -> [AIPatient]
}

class GetAIPatientsUseCase: GetAIPatientsUseCaseProtocol {
    private let repository: AIPatientRepositoryProtocol
    
    init(repository: AIPatientRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> [AIPatient] {
        return try await repository.getPatients()
    }
}
