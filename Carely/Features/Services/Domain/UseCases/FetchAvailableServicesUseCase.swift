//
//  FetchAvailableServicesUseCaseProtocol.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 22/07/2026.
//


import Foundation

protocol FetchAvailableServicesUseCaseProtocol {
    func execute() async throws -> [CareService]
}

struct FetchAvailableServicesUseCase: FetchAvailableServicesUseCaseProtocol {
    let repository: CareRequestRepositoryProtocol
    func execute() async throws -> [CareService] {
        try await repository.fetchAvailableServices()
    }
}


