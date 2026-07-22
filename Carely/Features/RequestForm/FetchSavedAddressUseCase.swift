//
//  FetchSavedAddressUseCaseProtocol.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 22/07/2026.
//


protocol FetchSavedAddressUseCaseProtocol {
    func execute() async throws -> PatientAddress?
}

struct FetchSavedAddressUseCase: FetchSavedAddressUseCaseProtocol {
    let repository: CareRequestRepositoryProtocol
    func execute() async throws -> PatientAddress? {
        try await repository.fetchSavedAddress()
    }
}