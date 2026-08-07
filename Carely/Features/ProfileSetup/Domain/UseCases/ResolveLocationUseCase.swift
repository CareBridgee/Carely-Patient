//
//  ResolveLocationUseCase.swift
//  Carely
//

import Foundation
import CoreLocation

final class ResolveLocationUseCase {

    private let repository: ProfileSetupRepositoryProtocol

    init(repository: ProfileSetupRepositoryProtocol) {
        self.repository = repository
    }

    func execute(for suggestion: SearchSuggestion) async throws -> CLLocationCoordinate2D {
        return try await repository.resolveLocation(for: suggestion)
    }
}
