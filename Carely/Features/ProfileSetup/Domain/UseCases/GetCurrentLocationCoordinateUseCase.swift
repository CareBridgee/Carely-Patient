//
//  GetCurrentLocationCoordinateUseCase.swift
//  Carely
//

import Foundation
import CoreLocation

final class GetCurrentLocationCoordinateUseCase {

    private let repository: HomeAddressRepositoryProtocol

    init(repository: HomeAddressRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async -> CLLocationCoordinate2D? {
        return await repository.currentCoordinateIfAuthorized()
    }
}
