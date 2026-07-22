//
//  GetUpcomingBookingsUseCase.swift
//  Carely
//
//  Created by Mina on 22/07/2026.
//

import Foundation
 
protocol GetUpcomingBookingsUseCaseProtocol {
    func execute() async throws -> [UpcomingBooking]
}
 
final class GetUpcomingBookingsUseCase: GetUpcomingBookingsUseCaseProtocol {
    private let repository: HomeRepositoryProtocol
 
    init(repository: HomeRepositoryProtocol) {
        self.repository = repository
    }
 
    func execute() async throws -> [UpcomingBooking] {
        try await repository.fetchUpcomingBookings()
    }
}
 
