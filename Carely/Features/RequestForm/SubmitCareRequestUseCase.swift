//
//  SubmitCareRequestUseCaseProtocol.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 22/07/2026.
//



protocol SubmitCareRequestUseCaseProtocol {
    func execute(_ request: CareRequest) async throws
}

struct SubmitCareRequestUseCase: SubmitCareRequestUseCaseProtocol {
    let repository: CareRequestRepositoryProtocol
    func execute(_ request: CareRequest) async throws {
        try await repository.submitCareRequest(request)
    }
}
