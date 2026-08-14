//
//  HistoryRepositoryProtocol.swift
//  Carely
//
//  Created by Mina on 14/08/2026.
//

import Foundation
 
protocol HistoryRepositoryProtocol {
    func fetchHistory() async throws -> [VisitHistoryItem]
    func fetchVisitDetail(id: String) async throws -> VisitDetail
}
 
