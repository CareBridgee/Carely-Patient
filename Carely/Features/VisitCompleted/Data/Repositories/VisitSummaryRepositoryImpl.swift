//
//  VisitSummaryRepositoryImpl.swift
//  Carely
//
//  Created by Mina on 24/07/2026.
//

import Foundation
 
final class VisitSummaryRepositoryImpl: VisitSummaryRepositoryProtocol {
 
    private let simulatedDelayNanoseconds: UInt64 = 500_000_000
 
    init() {}
 
    func fetchVisitSummary(visitId: String) async throws -> VisitSummary {
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
        try await Task.sleep(nanoseconds: simulatedDelayNanoseconds)
        // In a real implementation this would POST to the backend.
    }
}
 
