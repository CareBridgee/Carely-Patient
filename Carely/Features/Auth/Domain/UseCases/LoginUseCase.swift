//
//  LoginUseCase.swift
//  Carely
//

import Foundation

protocol LoginUseCaseProtocol {
    func execute(phoneNumber: String) async throws
}

struct LoginUseCase: LoginUseCaseProtocol {
    private let repository: AuthRepositoryProtocol

    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    func execute(phoneNumber: String) async throws {
        try await repository.login(phoneNumber: phoneNumber)
    }
}
