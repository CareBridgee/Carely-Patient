//
//  HomeRepositoryProtocol.swift
//  Carely
//
//  Created by Mina on 22/07/2026.
//

import Foundation
 
enum HomeError: LocalizedError, Equatable {
    case serviceNotFound
    case network
    case unknown
 
    var errorDescription: String? {
        switch self {
        case .serviceNotFound:
            return "We couldn't find details for this service."
        case .network:
            return "Something went wrong. Please check your connection and try again."
        case .unknown:
            return "Something went wrong. Please try again."
        }
    }
}
 
protocol HomeRepositoryProtocol {
    func fetchGreetingName() async throws -> String
    func fetchServiceCategories() async throws -> [ServiceCategory]
    func fetchUpcomingBookings() async throws -> [UpcomingBooking]
    func fetchServiceDetail(id: String) async throws -> ServiceDetail
    func searchServiceCategories(query: String) async throws -> [ServiceCategory]
}
 
