//
//  HomeRepositoryImpl.swift
//  Carely
//
//  Created by Mina on 22/07/2026.
//

import Foundation

final class HomeRepositoryImpl: HomeRepositoryProtocol {

    private let simulatedDelayNanoseconds: UInt64 = 600_000_000
    private let serviceTypeService: ServiceTypeServiceProtocol

    /// In-memory cache so Home + AllServices + ServiceDetails don't each
    /// trigger their own round trip to /api/v1/service-types.
    private var cachedServiceTypes: [ServiceTypeDTO]?

    init(serviceTypeService: ServiceTypeServiceProtocol) {
        self.serviceTypeService = serviceTypeService
    }

    // MARK: - Greeting

    // TODO: Wire to a real "current user" endpoint once available.
    func fetchGreetingName() async throws -> String {
        try await Task.sleep(nanoseconds: simulatedDelayNanoseconds)
        return "Elena"
    }

    // MARK: - Categories

    func fetchServiceCategories() async throws -> [ServiceCategory] {
        let serviceTypes = try await loadServiceTypes()
        return Self.mapToCategories(serviceTypes)
    }

    func searchServiceCategories(query: String) async throws -> [ServiceCategory] {
        let serviceTypes = try await loadServiceTypes()
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return Self.mapToCategories(serviceTypes) }

        let filtered = serviceTypes.filter {
            $0.name.localizedCaseInsensitiveContains(trimmed) ||
           ($0.description ?? "").localizedCaseInsensitiveContains(trimmed) ||
            
            $0.category.localizedCaseInsensitiveContains(trimmed)
        }
        return Self.mapToCategories(filtered)
    }

    // MARK: - Bookings

    // TODO: Wire to a real bookings endpoint once available.
    func fetchUpcomingBookings() async throws -> [UpcomingBooking] {
        try await Task.sleep(nanoseconds: simulatedDelayNanoseconds)
        return [
            UpcomingBooking(
                id: "booking-1",
                providerName: "Nurse Sarah Jenkins",
                providerImageName: "person.crop.circle.fill",
                serviceName: "General Nursing Care",
                status: .confirmed,
                dateTimeText: "Today, 02:30 PM"
            )
        ]
    }

    // MARK: - Service Detail

    func fetchServiceDetail(id: String) async throws -> ServiceDetail {
        do {
            let dto = try await serviceTypeService.getServiceType(id: id)
            return ServiceDetail(serviceType: dto)
        } catch let error as NetworkError {
            switch error {
            case .server(let statusCode, _) where statusCode == 404:
                throw HomeError.serviceNotFound
            case .unauthorized, .sessionExpired:
                throw error
            default:
                throw HomeError.network
            }
        } catch {
            throw HomeError.unknown
        }
    }

    // MARK: - Networking

    private func loadServiceTypes(forceRefresh: Bool = false) async throws -> [ServiceTypeDTO] {
        if !forceRefresh, let cached = cachedServiceTypes {
            return cached
        }
        do {
            let serviceTypes = try await serviceTypeService.getServiceTypes()
            cachedServiceTypes = serviceTypes
            return serviceTypes
        } catch is NetworkError {
            throw HomeError.network
        } catch {
            throw HomeError.unknown
        }
    }

    private static func mapToCategories(_ serviceTypes: [ServiceTypeDTO]) -> [ServiceCategory] {
        serviceTypes.enumerated().map { index, dto in
            ServiceCategory(serviceType: dto, index: index)
        }
    }
}
