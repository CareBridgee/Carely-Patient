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
        guard let service = historyService else {
            throw NetworkError.server(statusCode: 500, message: "Service unavailable")
        }

        let detail = try await service.getRequestDetail(id: visitId)
        let nurseName = [detail.nurse?.firstName, detail.nurse?.lastName]
            .compactMap { $0 }
            .joined(separator: " ")
        let formattedNurseName = nurseName.isEmpty ? "Assigned Nurse" : nurseName
        let serviceTypeName = detail.serviceType?.name ?? "Nursing Visit"
        
        let completedDateText: String
        if let dateStr = detail.preferredDate, !dateStr.isEmpty {
            completedDateText = dateStr
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, yyyy"
            completedDateText = formatter.string(from: Date())
        }
        
        let acceptedOfferPrice = detail.offers?.first(where: { $0.status == "ACCEPTED" })?.proposedPrice
        let priceValue = acceptedOfferPrice ?? detail.serviceType?.basePrice
        let priceText = priceValue.map { String(format: "$%.2f", $0) } ?? "Paid"
        
        return VisitSummary(
            id: visitId,
            isVerified: true,
            medicalProfessionalName: formattedNurseName,
            serviceType: serviceTypeName,
            completedDateText: completedDateText,
            totalAmountText: priceText
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
 
