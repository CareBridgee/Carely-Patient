//
//  VisitSummaryRepositoryImpl.swift
//  Carely
//
//  Created by Mina on 24/07/2026.
//

import Foundation
 
final class VisitSummaryRepositoryImpl: VisitSummaryRepositoryProtocol {
 
    private let historyService: HistoryServiceProtocol?
    private let networkClient: NetworkClientProtocol?
    private let simulatedDelayNanoseconds: UInt64 = 500_000_000

    init(historyService: HistoryServiceProtocol? = nil, networkClient: NetworkClientProtocol? = nil) {
        self.historyService = historyService
        self.networkClient = networkClient
    }
 
    func fetchVisitSummary(visitId: String) async throws -> VisitSummary {
        if let service = historyService {
            do {
                let detail = try await service.getRequestDetail(id: visitId)
                let nurseName = [detail.nurse?.firstName, detail.nurse?.lastName]
                    .compactMap { $0 }
                    .joined(separator: " ")
                let formattedNurseName = nurseName.isEmpty ? "Assigned Nurse" : nurseName
                let serviceTypeName = detail.serviceType?.name ?? "Nursing Visit"
                let durationText = detail.durationMinutes.map { "\($0) mins" } ?? "60 mins"
                
                let completedDateText: String
                if let dateStr = detail.preferredDate {
                    completedDateText = dateStr
                } else {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "MMM d"
                    completedDateText = formatter.string(from: Date())
                }
                
                return VisitSummary(
                    id: visitId,
                    isVerified: true,
                    medicalProfessionalName: formattedNurseName,
                    serviceType: serviceTypeName,
                    visitDurationText: durationText,
                    completedDateText: completedDateText,
                    totalAmountText: "$425.00"
                )
            } catch {
                print("[VisitSummaryRepositoryImpl] Error fetching detail from history API: \(error)")
            }
        }

        try await Task.sleep(nanoseconds: simulatedDelayNanoseconds)
        return VisitSummary(
            id: visitId,
            isVerified: true,
            medicalProfessionalName: "Sarah Mitchell",
            serviceType: "Wound Care",
            visitDurationText: "60 mins",
            completedDateText: "Oct 24",
            totalAmountText: "$85.00"
        )
    }
 
    func submitVisitRating(_ rating: VisitRating) async throws {
        if let client = networkClient {
            let body = CreateReviewRequestDTO(
                serviceRequestId: rating.visitId,
                rating: rating.stars,
                reviewText: rating.reviewText,
                isAnonymous: rating.isAnonymous
            )
            let endpoint = ReviewEndpoint.createReview(body)
            let response: ReviewResponseDTO = try await client.request(endpoint)
            print("[VisitSummaryRepositoryImpl] Review created successfully with id: \(response.id)")
        } else {
            try await Task.sleep(nanoseconds: simulatedDelayNanoseconds)
        }
    }
}
 
