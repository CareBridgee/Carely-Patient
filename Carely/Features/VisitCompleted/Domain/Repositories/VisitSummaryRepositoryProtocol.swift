//
//  VisitSummaryRepositoryProtocol.swift
//  Carely
//
//  Created by Mina on 24/07/2026.
//

import Foundation
 
protocol VisitSummaryRepositoryProtocol {
    func fetchVisitSummary(visitId: String) async throws -> VisitSummary
    func submitVisitRating(_ rating: VisitRating) async throws
}
