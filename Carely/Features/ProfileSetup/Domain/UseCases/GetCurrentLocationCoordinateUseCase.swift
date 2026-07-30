//
//  GetCurrentLocationCoordinateUseCase.swift
//  Carely
//

import Foundation
import CoreLocation

final class GetCurrentLocationCoordinateUseCase {

    private let repository: ProfileSetupRepositoryProtocol

    init(repository: ProfileSetupRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async -> CLLocationCoordinate2D? {
        return await repository.currentCoordinateIfAuthorized()
    }
}
