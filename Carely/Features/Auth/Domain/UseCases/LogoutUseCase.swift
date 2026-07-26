//
//  LogoutUseCase.swift
//  Carely
//

import Foundation

protocol LogoutUseCaseProtocol {
    func execute() async throws
}

struct LogoutUseCase: LogoutUseCaseProtocol {
    private let repository: AuthRepositoryProtocol
    private let tokenStore: TokenStoring
    private let sessionManager: SessionManager

    init(
        repository: AuthRepositoryProtocol,
        tokenStore: TokenStoring,
        sessionManager: SessionManager
    ) {
        self.repository = repository
        self.tokenStore = tokenStore
        self.sessionManager = sessionManager
    }

    func execute() async throws {
        if let refreshToken = tokenStore.getRefreshToken() {
            try await repository.logout(refreshToken: refreshToken)
        }

        tokenStore.clearTokens()

        await MainActor.run {
            sessionManager.setLoggedOut()
        }
    }
}
