//
//  SubmitCareRequestUseCaseProtocol.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 22/07/2026.
//


protocol FetchPatientsUseCaseProtocol {
    func execute() async throws -> [ServiceRequestPatient]
}
struct FetchPatientsUseCase: FetchPatientsUseCaseProtocol {
    let repository: CareRequestRepositoryProtocol
    func execute() async throws -> [ServiceRequestPatient] { try await repository.fetchPatients() }
}

protocol FetchProfileAddressUseCaseProtocol {
    func execute(profileId: String) async throws -> ServiceRequestAddress?
}
struct FetchProfileAddressUseCase: FetchProfileAddressUseCaseProtocol {
    let repository: CareRequestRepositoryProtocol
    func execute(profileId: String) async throws -> ServiceRequestAddress? {
        try await repository.fetchAddress(profileId: profileId)
    }
}

protocol SubmitCareRequestUseCaseProtocol {
    func execute(_ request: CareRequest) async throws -> ServiceRequestResult
}
struct SubmitCareRequestUseCase: SubmitCareRequestUseCaseProtocol {
    let repository: CareRequestRepositoryProtocol
    func execute(_ request: CareRequest) async throws -> ServiceRequestResult {
        try await repository.submitCareRequest(request)
    }
}
