//
//  UpdateProfileUseCase.swift
//  Carely
//

import Foundation
import UIKit

protocol UpdateProfileUseCaseProtocol {
    func execute(id: String, params: ProfileUpdateRequestParams, image: UIImage?) async throws
}

final class UpdateProfileUseCase: UpdateProfileUseCaseProtocol {
    private let repository: ProfileRepositoryProtocol

    init(repository: ProfileRepositoryProtocol) {
        self.repository = repository
    }

    /// Updates PUT /api/v1/profiles/{id} AND PUT /api/v1/users/me concurrently
    /// via ProfileRepositoryImpl → ProfileNetworkService.
    func execute(id: String, params: ProfileUpdateRequestParams, image: UIImage?) async throws {
        try await repository.updateProfile(id: id, params: params, image: image)
    }
}
