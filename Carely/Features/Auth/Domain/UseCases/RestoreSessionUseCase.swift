import Foundation

protocol RestoreSessionUseCaseProtocol: Sendable {
    func execute() async throws
}

final class RestoreSessionUseCase: RestoreSessionUseCaseProtocol {
    private let repository: AuthRepositoryProtocol
    private let sessionManager: SessionManager

    init(repository: AuthRepositoryProtocol, sessionManager: SessionManager) {
        self.repository = repository
        self.sessionManager = sessionManager
    }

    func execute() async throws {
        do {
            let user = try await repository.getUser()
            
            // On success, update SessionManager and complete restoration
            await MainActor.run {
                sessionManager.completeRestoration(user: user)
            }
        } catch {
            // Let the caller handle the error (e.g. going to logged out or showing retry)
            throw error
        }
    }
}
