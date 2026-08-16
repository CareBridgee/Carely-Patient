//
//  HomeRepositoryImpl.swift
//  Carely
//
//  Created by Mina on 22/07/2026.
//

import Foundation

final class HomeRepositoryImpl: HomeRepositoryProtocol {

    /// Number of items shown in the Home "History" preview before the user
    /// taps "See All" to go to the full History screen.
    private let homePreviewBookingCount = 3

    private let simulatedDelayNanoseconds: UInt64 = 600_000_000
    private let serviceTypeService: ServiceTypeServiceProtocol
    private let historyService: HistoryServiceProtocol

    init(serviceTypeService: ServiceTypeServiceProtocol, historyService: HistoryServiceProtocol) {
        self.serviceTypeService = serviceTypeService
        self.historyService = historyService
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

    /// Backs the "History" preview on the Home screen. Pulls from the same
    /// GET /api/v1/service-requests/confirmed endpoint the full History
    /// screen uses, so both surfaces reflect real API data instead of the
    /// old hardcoded mock booking.
    func fetchUpcomingBookings() async throws -> [UpcomingBooking] {
        do {
            let dtos = try await historyService.getConfirmedRequests()
            return dtos
                .filter { VisitStatus(rawStatus: $0.status) != .cancelled }
                .prefix(homePreviewBookingCount)
                .map(Self.mapToUpcomingBooking)
        } catch is NetworkError {
            throw HomeError.network
        } catch {
            throw HomeError.unknown
        }
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

    private func loadServiceTypes() async throws -> [ServiceTypeDTO] {
        do {
            return try await serviceTypeService.getServiceTypes()
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

    private static func mapToUpcomingBooking(_ dto: ServiceRequestHistoryDTO) -> UpcomingBooking {
        UpcomingBooking(
            id: dto.serviceRequestId,
            providerName: nurseDisplayName(dto.nurse),
            providerImageName: "person.crop.circle.fill",
            providerImageUrl: dto.nurse?.profileImageUrl,
            serviceName: dto.serviceName ?? "Service",
            status: BookingStatus(visitStatus: VisitStatus(rawStatus: dto.status)),
            dateTimeText: [dto.preferredDate, dto.preferredTime?.displayText]
                .compactMap { $0 }
                .filter { !$0.isEmpty }
                .joined(separator: ", ")
        )
    }

    private static func nurseDisplayName(_ nurse: NurseDetailsDTO?) -> String {
        guard let nurse else { return "Care Provider" }
        let name = [nurse.firstName, nurse.lastName]
            .compactMap { $0 }
            .joined(separator: " ")
            .trimmingCharacters(in: .whitespaces)
        return name.isEmpty ? "Care Provider" : name
    }

    // MARK: - Active Visit

    func fetchActiveVisit() async throws -> ConfirmedOffer? {
        do {
            let detail = try await historyService.getCurrentRequest()
            let status = detail.status?.uppercased() ?? ""
            guard status == "ACCEPTED" || status == "IN_PROGRESS" || status == "SEARCHING" || status == "BOOKING" else {
                return nil
            }
            let nurseName = [detail.nurse?.firstName, detail.nurse?.lastName].compactMap { $0 }.joined(separator: " ")
            let nurseDetails = ConfirmedOffer.NurseDetails(
                id: detail.nurse?.id ?? "",
                fullName: nurseName.isEmpty ? "Assigned Nurse" : nurseName,
                title: "Nurse",
                specialty: detail.serviceType?.name ?? "General Nursing",
                profileImageUrl: detail.nurse?.profileImageUrl ?? "",
                rating: detail.nurse?.ratingAvg ?? 5.0,
                reviewsCount: detail.nurse?.totalReviews ?? 0
            )
            return ConfirmedOffer(
                id: detail.serviceRequestId,
                status: status,
                estimatedArrival: "15 mins",
                distanceKm: detail.distanceKm ?? 2.0,
                qrCodeData: detail.serviceRequestId,
                cancellationDeadline: "5 mins",
                nurse: nurseDetails,
                contact: ConfirmedOffer.ContactDetails(phoneNumber: "", chatChannelId: detail.serviceRequestId)
            )
        } catch {
            return nil
        }
    }
}
