//
//  RequestOTPDevUseCase.swift
//  Carely
//

import Foundation

protocol RequestOTPDevUseCaseProtocol {
    func execute(phoneNumber: String) async throws -> DevOTPResponse
}

struct RequestOTPDevUseCase: RequestOTPDevUseCaseProtocol {
    private let repository: AuthRepositoryProtocol

    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    func execute(phoneNumber: String) async throws -> DevOTPResponse {
        try await repository.requestOTPDev(phoneNumber: phoneNumber)
    }
}
