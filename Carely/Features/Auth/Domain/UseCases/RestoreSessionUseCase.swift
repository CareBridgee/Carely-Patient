import Foundation

protocol RestoreSessionUseCaseProtocol: Sendable {
    func execute() async throws
}

final class RestoreSessionUseCase: RestoreSessionUseCaseProtocol {
    private let repository: AuthRepositoryProtocol
    private let sessionManager: SessionManager
    private let profileRepository: ProfileRepositoryProtocol

    init(
        repository: AuthRepositoryProtocol,
        sessionManager: SessionManager,
        profileRepository: ProfileRepositoryProtocol
    ) {
        self.repository = repository
        self.sessionManager = sessionManager
        self.profileRepository = profileRepository
    }

    func execute() async throws {
        do {
            let user = try await repository.getUser()
            
            // Prefetch primary profile and family members in parallel so they are ready across all tabs on launch
            async let fetchProfile: () = {
                _ = try? await self.profileRepository.fetchPatientProfile()
            }()
            async let fetchFamily: () = {
                _ = try? await self.profileRepository.fetchFamilyMembers()
            }()
            _ = await (fetchProfile, fetchFamily)
            
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
