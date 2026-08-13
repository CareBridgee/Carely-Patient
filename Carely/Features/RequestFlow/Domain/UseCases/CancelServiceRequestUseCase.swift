//
//  CancelServiceRequestUseCase.swift
//  Carely
//

import Foundation

protocol CancelServiceRequestUseCaseProtocol {
    func execute(serviceRequestId: String) async throws
}

struct CancelServiceRequestUseCase: CancelServiceRequestUseCaseProtocol {
    private let repository: OfferSearchingRepositoryProtocol

    init(repository: OfferSearchingRepositoryProtocol) {
        self.repository = repository
    }

    func execute(serviceRequestId: String) async throws {
        try await repository.cancelServiceRequest(serviceRequestId: serviceRequestId)
    }
}
