import Foundation

protocol DeleteProfileUseCaseProtocol {
    func execute(id: String) async throws
}

final class DeleteProfileUseCase: DeleteProfileUseCaseProtocol {
    private let repository: ProfileRepositoryProtocol

    init(repository: ProfileRepositoryProtocol) {
        self.repository = repository
    }

    func execute(id: String) async throws {
        try await repository.deleteProfile(id: id)
    }
}
